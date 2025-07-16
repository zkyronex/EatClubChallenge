import UIKit

protocol FeatureRouting: AnyObject {
    var navigationController: UINavigationController { get }
    var childRouters: [FeatureRouting] { get set }
    var parentRouter: FeatureRouting? { get set }
    
    func start()
}

extension FeatureRouting {
    func addChild(_ router: FeatureRouting) {
        childRouters.append(router)
        router.parentRouter = self
    }
    
    func removeChild(_ router: FeatureRouting) {
        childRouters.removeAll { $0 === router }
    }
    
    func removeFromParent() {
        parentRouter?.removeChild(self)
    }
}