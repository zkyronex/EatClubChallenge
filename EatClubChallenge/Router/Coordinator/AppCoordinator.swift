import UIKit

final class AppCoordinator {
    private let window: UIWindow
    private let rootNavigationController: UINavigationController
    private var rootRouter: FeatureRouting?
    
    init(window: UIWindow) {
        self.window = window
        self.rootNavigationController = UINavigationController()
        
        // Configure navigation bar appearance if needed
        configureNavigationBarAppearance()
    }
    
    func start() {
        window.rootViewController = rootNavigationController
        window.makeKeyAndVisible()
        
        // Start with restaurant feature as the root
        let restaurantRouter = RestaurantRouter(navigationController: rootNavigationController)
        rootRouter = restaurantRouter
        restaurantRouter.start()
    }
    
    private func configureNavigationBarAppearance() {
        // Configure navigation bar appearance globally
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }
}