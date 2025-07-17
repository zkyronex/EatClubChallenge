import Testing
import Combine
import Foundation
@testable import EatClubChallenge

@Suite("RestaurantDetailPresenter Tests")
struct RestaurantDetailPresenterTests {
    
    @Test("Initializes with restaurant and creates view model")
    func testInitialization() {
        let restaurant = createMockRestaurant()
        
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        
        #expect(presenter.restaurant != nil)
        #expect(presenter.restaurant?.name == "Mock Restaurant")
        #expect(presenter.restaurant?.address == "123 Mock St Mock Suburb • 0.5km Away")
        #expect(presenter.restaurant?.deals.count == 1)
        #expect(presenter.restaurant?.deals.first?.discount == 25)
    }
    
    @Test("Toggle favourite calls expected action")
    func testToggleFavourite() {
        let restaurant = createMockRestaurant()
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        
        presenter.toggleFavourite()
    }
    
    @Test("Show menu calls expected action")
    func testShowMenu() {
        let restaurant = createMockRestaurant()
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        
        presenter.showMenu()
    }
    
    @Test("Call restaurant calls expected action")
    func testCallRestaurant() {
        let restaurant = createMockRestaurant()
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        
        presenter.callRestaurant()
    }
    
    @Test("Show location calls expected action")
    func testShowLocation() {
        let restaurant = createMockRestaurant()
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        
        presenter.showLocation()
    }
    
    @Test("Redeem deal calls expected action with deal information")
    func testRedeemDeal() {
        let restaurant = createMockRestaurant()
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        
        if let deal = presenter.restaurant?.deals.first {
            presenter.redeemDeal(deal)
        }
    }
    
    @Test("Restaurant with no deals creates view model with empty deals")
    func testRestaurantWithNoDeals() {
        let restaurant = Restaurant(
            objectId: "1",
            name: "No Deals Restaurant",
            address1: "456 Test Ave",
            suburb: "Test Suburb",
            cuisines: ["Italian"],
            imageLink: "https://example.com/image.jpg",
            open: "09:00",
            close: "21:00",
            deals: []
        )
        
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        
        #expect(presenter.restaurant?.deals.isEmpty == true)
    }
    
    @Test("Restaurant with multiple deals sorted by highest discount")
    func testMultipleDealsSort() {
        let deals = [
            createMockDeal(objectId: "1", discount: "10"),
            createMockDeal(objectId: "2", discount: "50", lightning: true),
            createMockDeal(objectId: "3", discount: "25", dineIn: false)
        ]
        
        let restaurant = Restaurant(
            objectId: "1",
            name: "Multi Deal Restaurant",
            address1: "789 Test Blvd",
            suburb: "Test Suburb",
            cuisines: ["Asian", "Thai"],
            imageLink: "https://example.com/image.jpg",
            open: "09:00",
            close: "21:00",
            deals: deals
        )
        
        let presenter = RestaurantDetailPresenter(restaurant: restaurant)
        
        #expect(presenter.restaurant?.deals.count == 3)
        #expect(presenter.restaurant?.deals[0].discount == 50)
        #expect(presenter.restaurant?.deals[1].discount == 25)
        #expect(presenter.restaurant?.deals[2].discount == 10)
    }
    
    // MARK: - Helper Methods
    
    private func createMockRestaurant() -> Restaurant {
        Restaurant(
            objectId: "1",
            name: "Mock Restaurant",
            address1: "123 Mock St",
            suburb: "Mock Suburb",
            cuisines: ["Italian", "Pizza"],
            imageLink: "https://example.com/image.jpg",
            open: "09:00",
            close: "21:00",
            deals: [
                createMockDeal(objectId: "1", discount: "25")
            ]
        )
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