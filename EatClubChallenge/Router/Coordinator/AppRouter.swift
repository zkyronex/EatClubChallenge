import UIKit

final class AppRouter: Router {
    
    let viewController = UIViewController()
    
    private let rootNavigationController = UINavigationController()
    
    override init() {
        super.init()
        
        configureNavigationBarAppearance()
        
        let restaurantsRouter = RestaurantRouter()
        add(child: restaurantsRouter)
        prepare(childViewController: restaurantsRouter.navigationController)
    }
    
    private func configureNavigationBarAppearance() {
        // Configure navigation bar appearance globally
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
    
    private func prepare(childViewController: UIViewController) {
        viewController.children.forEach {
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }
        viewController.addChild(childViewController)

        viewController.view.addSubview(childViewController.view)
        childViewController.view.translatesAutoresizingMaskIntoConstraints = false
        childViewController.view.topAnchor.constraint(equalTo: viewController.view.topAnchor).isActive = true
        childViewController.view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor).isActive = true
        childViewController.view.leadingAnchor.constraint(equalTo: viewController.view.leadingAnchor).isActive = true
        childViewController.view.trailingAnchor.constraint(equalTo: viewController.view.trailingAnchor).isActive = true
        childViewController.didMove(toParent: viewController)
    }
}
