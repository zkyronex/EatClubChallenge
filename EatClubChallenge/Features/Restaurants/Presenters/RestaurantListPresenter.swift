import Foundation
import Combine

protocol RestaurantFetching {
    func fetchRestaurants() -> AnyPublisher<[Restaurant], APIError>
}

protocol RestaurantListPresenting: ObservableObject {
    var restaurants: [RestaurantViewModel] { get }
    var filteredRestaurants: [RestaurantViewModel] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    var searchText: String { get set }
    
    func loadRestaurants()
    func refresh()
}

final class RestaurantListPresenter: RestaurantListPresenting {
    @Published private(set) var restaurants: [RestaurantViewModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    @Published var searchText: String = ""
    
    private var allRestaurants: [RestaurantViewModel] = []
    private let fetcher: RestaurantFetching
    private var cancellables = Set<AnyCancellable>()
    
    var filteredRestaurants: [RestaurantViewModel] {
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
                restaurants.map { RestaurantViewModel(from: $0) }
            }
            .map { viewModels in
                // Sort by best deals first (highest discount percentage)
                viewModels.sorted { vm1, vm2 in
                    vm1.maxDiscount > vm2.maxDiscount
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
                receiveValue: { [weak self] viewModels in
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
}
