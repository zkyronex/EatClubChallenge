import Foundation
import Combine

final class RestaurantFetcher: RestaurantFetching {
    private let apiService: APIServicing
    
    init(apiService: APIServicing = APIService()) {
        self.apiService = apiService
    }
    
    func fetchRestaurants() -> AnyPublisher<[Restaurant], APIError> {
        let endpoint = RestaurantEndpoint.fetchRestaurants
        
        return apiService.request(endpoint, responseType: RestaurantResponse.self)
            .map(\.restaurants)
            .eraseToAnyPublisher()
    }
}
