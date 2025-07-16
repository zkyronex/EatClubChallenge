import Combine
import UIKit
import SwiftUI

final class RestaurantRouter: Router, Routable {
    
    let navigationController: UINavigationController
    
    var finish: AnyPublisher<Void, Never> {
        Empty<Void, Never>(completeImmediately: false).eraseToAnyPublisher()
    }

    var cancellables = Set<AnyCancellable>()

    override init() {
        let presenter = RestaurantListPresenter()
        let view = RestaurantListView(presenter: presenter)
        let viewController = UIHostingController(rootView: view)
        self.navigationController = UINavigationController(rootViewController: viewController)
        
        super.init()
        
        presenter.detailsSubject.sink { [weak self] restaurant in
            self?.showRestaurantDetail(restaurant: restaurant)
        }
        .store(in: &presenter.cancellables)
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
