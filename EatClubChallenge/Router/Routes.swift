import UIKit

enum Route {
    case restaurantList
    case restaurantDetail(id: String)
    
    var viewController: UIViewController {
        switch self {
        case .restaurantList:
            let presenter = RestaurantListPresenter()
            let view = RestaurantListView(presenter: presenter)
            return UIHostingController(rootView: view)
            
        case .restaurantDetail(let id):
            // Placeholder for future implementation
            let view = Text("Restaurant Detail: \(id)")
            return UIHostingController(rootView: view)
        }
    }
}

import SwiftUI // Temporary import for placeholder Text view