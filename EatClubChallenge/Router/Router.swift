import UIKit

protocol Routing {
    func navigate(to route: Route)
    func pop()
    func popToRoot()
    func present(_ route: Route, animated: Bool, completion: (() -> Void)?)
    func dismiss(animated: Bool, completion: (() -> Void)?)
}

final class Router: Routing {
    private weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func navigate(to route: Route) {
        let viewController = route.viewController
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func present(_ route: Route, animated: Bool = true, completion: (() -> Void)? = nil) {
        let viewController = route.viewController
        navigationController?.present(viewController, animated: animated, completion: completion)
    }
    
    func dismiss(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController?.dismiss(animated: animated, completion: completion)
    }
}

// MARK: - App Router Singleton
final class AppRouter {
    static let shared = AppRouter()
    private var router: Router?
    
    private init() {}
    
    func configure(with navigationController: UINavigationController) {
        self.router = Router(navigationController: navigationController)
    }
    
    var current: Routing? {
        return router
    }
}