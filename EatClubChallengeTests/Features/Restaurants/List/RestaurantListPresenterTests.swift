import Testing
import Combine
import Foundation
@testable import EatClubChallenge

@Suite("RestaurantListPresenter Tests")
struct RestaurantListPresenterTests {
    
    // MARK: - Mock Fetcher
    
    class MockRestaurantFetcher: RestaurantFetching {
        var shouldFail = false
        var mockRestaurants: [Restaurant] = []
        var fetchDelay: TimeInterval = 0
        
        func fetchRestaurants() -> AnyPublisher<[Restaurant], APIError> {
            if shouldFail {
                return Fail(error: APIError.networkError(NSError(domain: "test", code: -1)))
                    .eraseToAnyPublisher()
            }
            
            if fetchDelay > 0 {
                return Just(mockRestaurants)
                    .setFailureType(to: APIError.self)
                    .delay(for: .seconds(fetchDelay), scheduler: RunLoop.main)
                    .eraseToAnyPublisher()
            }
            
            return Just(mockRestaurants)
                .setFailureType(to: APIError.self)
                .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Tests
    
    @Test("Initializes with empty state")
    func testInitialization() {
        let presenter = RestaurantListPresenter()
        
        #expect(presenter.restaurants.isEmpty)
        #expect(presenter.isLoading == false)
        #expect(presenter.errorMessage == nil)
        #expect(presenter.searchText.isEmpty)
        #expect(presenter.filteredRestaurants.isEmpty)
    }
    
    @Test("Load restaurants successfully")
    func testLoadRestaurantsSuccess() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.mockRestaurants = createMockRestaurants()
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        
        presenter.loadRestaurants()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(presenter.isLoading == false)
        #expect(presenter.errorMessage == nil)
        #expect(presenter.restaurants.count == 3)
        #expect(presenter.restaurants[0].name == "Restaurant C")
        #expect(presenter.restaurants[0].maxDiscount == 50)
        #expect(presenter.restaurants[1].name == "Restaurant B")
        #expect(presenter.restaurants[1].maxDiscount == 30)
        #expect(presenter.restaurants[2].name == "Restaurant A")
        #expect(presenter.restaurants[2].maxDiscount == 20)
    }
    
    @Test("Load restaurants with network error")
    func testLoadRestaurantsFailure() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.shouldFail = true
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        
        presenter.loadRestaurants()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(presenter.isLoading == false)
        #expect(presenter.errorMessage != nil)
        #expect(presenter.restaurants.isEmpty)
    }
    
    @Test("Loading state transitions correctly")
    func testLoadingState() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.mockRestaurants = createMockRestaurants()
        mockFetcher.fetchDelay = 0.1
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        
        #expect(presenter.isLoading == false)
        
        presenter.loadRestaurants()
        
        #expect(presenter.isLoading == true)
        
        try? await Task.sleep(nanoseconds: 200_000_000)
        
        #expect(presenter.isLoading == false)
    }
    
    @Test("Search filters restaurants correctly")
    func testSearchFiltering() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.mockRestaurants = createMockRestaurants()
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        presenter.loadRestaurants()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        presenter.searchText = "Restaurant A"
        
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        #expect(presenter.filteredRestaurants.count == 1)
        #expect(presenter.filteredRestaurants[0].name == "Restaurant A")
    }
    
    @Test("Search is case insensitive")
    func testSearchCaseInsensitive() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.mockRestaurants = createMockRestaurants()
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        presenter.loadRestaurants()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        presenter.searchText = "restaurant a"
        
        try? await Task.sleep(nanoseconds: 400_000_000)
        
        #expect(presenter.filteredRestaurants.count == 1)
        #expect(presenter.filteredRestaurants[0].name == "Restaurant A")
    }
    
    @Test("Empty search shows all restaurants")
    func testEmptySearch() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.mockRestaurants = createMockRestaurants()
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        presenter.loadRestaurants()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        presenter.searchText = ""
        
        #expect(presenter.filteredRestaurants.count == 3)
    }
    
    @Test("Refresh clears search and reloads")
    func testRefresh() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.mockRestaurants = createMockRestaurants()
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        presenter.loadRestaurants()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        presenter.searchText = "Test"
        presenter.refresh()
        
        #expect(presenter.searchText.isEmpty)
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(presenter.restaurants.count == 3)
    }
    
    @Test("Select restaurant sends correct model")
    func testSelectRestaurant() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.mockRestaurants = createMockRestaurants()
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        var receivedRestaurant: Restaurant?
        
        let cancellable = presenter.detailsSubject
            .sink { restaurant in
                receivedRestaurant = restaurant
            }
        
        presenter.loadRestaurants()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        let viewModel = presenter.restaurants[0]
        presenter.select(restaurant: viewModel)
        
        #expect(receivedRestaurant != nil)
        #expect(receivedRestaurant?.objectId == viewModel.id)
        #expect(receivedRestaurant?.name == "Restaurant C")
        
        cancellable.cancel()
    }
    
    @Test("Restaurants with no deals show correct discount")
    func testRestaurantWithNoDeals() async {
        let mockFetcher = MockRestaurantFetcher()
        mockFetcher.mockRestaurants = [
            Restaurant(
                objectId: "1",
                name: "No Deals Restaurant",
                address1: "123 Test St",
                suburb: "Test Suburb",
                cuisines: ["Italian"],
                imageLink: "https://example.com/image.jpg",
                open: "09:00",
                close: "21:00",
                deals: []
            )
        ]
        
        let presenter = RestaurantListPresenter(fetcher: mockFetcher)
        presenter.loadRestaurants()
        
        try? await Task.sleep(nanoseconds: 100_000_000)
        
        #expect(presenter.restaurants.count == 1)
        #expect(presenter.restaurants[0].maxDiscount == 0)
    }
    
    // MARK: - Helper Methods
    
    private func createMockRestaurants() -> [Restaurant] {
        [
            Restaurant(
                objectId: "1",
                name: "Restaurant A",
                address1: "123 A St",
                suburb: "A Suburb",
                cuisines: ["Italian", "Pizza"],
                imageLink: "https://example.com/a.jpg",
                open: "09:00",
                close: "21:00",
                deals: [
                    createMockDeal(objectId: "1", discount: "20")
                ]
            ),
            Restaurant(
                objectId: "2",
                name: "Restaurant B",
                address1: "456 B Ave",
                suburb: "B Suburb",
                cuisines: ["Asian", "Thai"],
                imageLink: "https://example.com/b.jpg",
                open: "10:00",
                close: "22:00",
                deals: [
                    createMockDeal(objectId: "2", discount: "15"),
                    createMockDeal(objectId: "3", discount: "30", dineIn: false, lightning: true)
                ]
            ),
            Restaurant(
                objectId: "3",
                name: "Restaurant C",
                address1: "789 C Blvd",
                suburb: "C Suburb",
                cuisines: ["Mexican", "Tex-Mex"],
                imageLink: "https://example.com/c.jpg",
                open: "11:00",
                close: "23:00",
                deals: [
                    createMockDeal(objectId: "4", discount: "50", lightning: true),
                    createMockDeal(objectId: "5", discount: "10")
                ]
            )
        ]
    }
    
    private func createMockDeal(
        objectId: String,
        discount: String,
        dineIn: Bool = true,
        lightning: Bool = false,
        qtyLeft: String = "10",
        open: String? = "09:00",
        close: String? = "21:00",
        start: String? = nil,
        end: String? = nil
    ) -> Deal {
        let json = """
        {
            "objectId": "\(objectId)",
            "discount": "\(discount)",
            "dineIn": \(dineIn),
            "lightning": \(lightning),
            "qtyLeft": "\(qtyLeft)",
            "open": \(open != nil ? "\"\(open!)\"" : "null"),
            "close": \(close != nil ? "\"\(close!)\"" : "null"),
            "start": \(start != nil ? "\"\(start!)\"" : "null"),
            "end": \(end != nil ? "\"\(end!)\"" : "null")
        }
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        return try! decoder.decode(Deal.self, from: data)
    }
}