import UIKit
import SwiftUI

final class RestaurantRouter: FeatureRouting {
    let navigationController: UINavigationController
    var childRouters: [FeatureRouting] = []
    weak var parentRouter: FeatureRouting?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showRestaurantList()
    }
    
    func showRestaurantList() {
        let presenter = RestaurantListPresenter()
        var view = RestaurantListView(presenter: presenter)
        
        // Set up navigation callback
        view.onRestaurantSelected = { [weak self] restaurant in
            self?.showRestaurantDetail(restaurant: restaurant)
        }
        
        let viewController = UIHostingController(rootView: view)
        navigationController.setViewControllers([viewController], animated: false)
    }
    
    func showRestaurantDetail(restaurant: RestaurantViewModel) {
        // Create detail presenter and view
        let detailView = RestaurantDetailView(restaurant: restaurant) { [weak self] deal in
            self?.showDealDetail(deal: deal)
        }
        
        let viewController = UIHostingController(rootView: detailView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showDealDetail(deal: DealViewModel) {
        // For now, show deal in the same navigation stack
        // If deals become complex, we can create a DealRouter as a child
        let dealView = DealDetailView(deal: deal)
        let viewController = UIHostingController(rootView: dealView)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// Temporary placeholder views for demonstration
struct RestaurantDetailView: View {
    let restaurant: RestaurantViewModel
    let onDealSelected: (DealViewModel) -> Void
    
    var body: some View {
        Text("Restaurant: \(restaurant.name)")
            .navigationTitle(restaurant.name)
    }
}

struct DealDetailView: View {
    let deal: DealViewModel
    
    var body: some View {
        Text("Deal: \(deal.discount)% off")
            .navigationTitle("Deal Details")
    }
}