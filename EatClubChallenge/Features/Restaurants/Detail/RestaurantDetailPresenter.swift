import Foundation
import Combine

protocol RestaurantDetailPresenting: ObservableObject {
    var restaurant: RestaurantDetailViewModel? { get }
    
    func toggleFavourite()
    func showMenu()
    func callRestaurant()
    func showLocation()
    func redeemDeal(_ deal: DealViewModel)
}

final class RestaurantDetailPresenter: RestaurantDetailPresenting {
    @Published private(set) var restaurant: RestaurantDetailViewModel?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(restaurant: Restaurant) {
        self.restaurant = RestaurantDetailViewModel(from: restaurant)
    }
    
    func toggleFavourite() {
        print("Toggle favourite for restaurant: \(restaurant?.name ?? "Unknown")")
    }
    
    func showMenu() {
        print("Show menu for restaurant: \(restaurant?.name ?? "Unknown")")
    }
    
    func callRestaurant() {
        print("Call restaurant: \(restaurant?.name ?? "Unknown")")
    }
    
    func showLocation() {
        print("Show location for restaurant: \(restaurant?.name ?? "Unknown")")
    }
    
    func redeemDeal(_ deal: DealViewModel) {
        print("Redeem deal: \(deal.discount)% off for restaurant: \(restaurant?.name ?? "Unknown")")
    }
}