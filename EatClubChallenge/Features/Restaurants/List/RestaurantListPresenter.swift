import Foundation
import Combine

protocol RestaurantFetching {
    func fetchRestaurants() -> AnyPublisher<[Restaurant], APIError>
}

protocol RestaurantListPresenting: ObservableObject {
    var restaurants: [RestaurantListViewModel] { get }
    var filteredRestaurants: [RestaurantListViewModel] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var searchText: String { get set }
    
    func loadRestaurants()
    func refresh()
    func select(restaurant: RestaurantListViewModel)
}

final class RestaurantListPresenter: RestaurantListPresenting {
    @Published private(set) var restaurants: [RestaurantListViewModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published var searchText: String = ""
    
    let detailsSubject = PassthroughSubject<Restaurant, Never>()
    var cancellables = Set<AnyCancellable>()
    
    private var allRestaurants: [RestaurantListViewModel] = []
    private var restaurantModels: [Restaurant] = []
    private let fetcher: RestaurantFetching
    
    var filteredRestaurants: [RestaurantListViewModel] {
        if searchText.isEmpty {
            return restaurants
        }
        
        let searchLower = searchText.lowercased()
        return restaurants.filter { restaurant in
            restaurant.name.lowercased().contains(searchLower) ||
            restaurant.cuisines.lowercased().contains(searchLower)
        }
    }
    
    init(fetcher: RestaurantFetching = RestaurantFetcher()) {
        self.fetcher = fetcher
        setupSearchDebounce()
    }
    
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
    
    func loadRestaurants() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        fetcher.fetchRestaurants()
            .map { restaurants in
                // Sort by best deals first (highest discount percentage)
                restaurants.sorted { r1, r2 in
                    let maxDiscount1 = r1.deals.compactMap { Int($0.discount) }.max() ?? 0
                    let maxDiscount2 = r2.deals.compactMap { Int($0.discount) }.max() ?? 0
                    return maxDiscount1 > maxDiscount2
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] restaurants in
                    self?.restaurantModels = restaurants
                    let viewModels = restaurants.map { RestaurantListViewModel(from: $0) }
                    self?.allRestaurants = viewModels
                    self?.restaurants = viewModels
                }
            )
            .store(in: &cancellables)
    }
    
    func refresh() {
        searchText = ""
        loadRestaurants()
    }
    
    func select(restaurant: RestaurantListViewModel) {
        // Find the corresponding Restaurant model and send it
        if let restaurantModel = restaurantModels.first(where: { $0.id == restaurant.id }) {
            detailsSubject.send(restaurantModel)
        }
    }
}
