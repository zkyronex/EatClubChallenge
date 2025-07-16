import Foundation
import Combine

protocol RestaurantListPresenting: ObservableObject {
    var restaurants: [RestaurantViewModel] { get }
    var isLoading: Bool { get }
    var errorMessage: String? { get }
    
    func loadRestaurants()
    func refresh()
}