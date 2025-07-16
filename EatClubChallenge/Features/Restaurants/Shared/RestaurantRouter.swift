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
        
        // Configure navigation items
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "person"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "slider.horizontal.3"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        // Set EatClub logo as title view
        let logoImageView = UIImageView(image: UIImage(named: "eat-club-icon"))
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        viewController.navigationItem.titleView = logoImageView
        
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
        
        // Configure navigation items for detail view
        viewController.navigationItem.title = "Restaurant Details"
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: nil,
            action: nil
        )
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showDealDetail(deal: DealViewModel) {
        // For now, show deal in the same navigation stack
        // If deals become complex, we can create a DealRouter as a child
    }
}
