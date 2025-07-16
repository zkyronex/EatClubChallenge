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
        let detailView = RestaurantDetailView(restaurant: restaurant)
        let viewController = UIHostingController(rootView: detailView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showDealDetail(deal: DealViewModel) {
        // For now, show deal in the same navigation stack
        // If deals become complex, we can create a DealRouter as a child
    }
}