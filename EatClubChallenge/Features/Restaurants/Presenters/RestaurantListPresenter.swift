import Foundation
import Combine

protocol RestaurantFetching {
    func fetchRestaurants() -> AnyPublisher<[Restaurant], APIError>
}

final class RestaurantListPresenter: RestaurantListPresenting {
    @Published private(set) var restaurants: [RestaurantViewModel] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let fetcher: RestaurantFetching
    private var cancellables = Set<AnyCancellable>()
    
    init(fetcher: RestaurantFetching = RestaurantFetcher()) {
        self.fetcher = fetcher
    }
    
    func loadRestaurants() {
        guard !isLoading else { return }
        
        isLoading = true
        errorMessage = nil
        
        fetcher.fetchRestaurants()
            .map { restaurants in
                restaurants.map { RestaurantViewModel(from: $0) }
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
                    self?.restaurants = viewModels
                }
            )
            .store(in: &cancellables)
    }
    
    func refresh() {
        loadRestaurants()
    }
}
