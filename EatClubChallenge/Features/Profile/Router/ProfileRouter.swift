import UIKit
import SwiftUI

// Example of another feature router that could be added later
final class ProfileRouter: FeatureRouting {
    let navigationController: UINavigationController
    var childRouters: [FeatureRouting] = []
    weak var parentRouter: FeatureRouting?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showProfile()
    }
    
    func showProfile() {
        let profileView = ProfileView { [weak self] in
            self?.showSettings()
        }
        
        let viewController = UIHostingController(rootView: profileView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showSettings() {
        // Settings could have its own router if complex enough
        let settingsRouter = SettingsRouter(navigationController: navigationController)
        addChild(settingsRouter)
        settingsRouter.start()
    }
}

// Example placeholder view
struct ProfileView: View {
    let onSettingsTapped: () -> Void
    
    var body: some View {
        VStack {
            Text("Profile")
            Button("Settings", action: onSettingsTapped)
        }
    }
}