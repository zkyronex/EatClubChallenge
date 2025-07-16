import UIKit
import SwiftUI

// Example of a child router
final class SettingsRouter: FeatureRouting {
    let navigationController: UINavigationController
    var childRouters: [FeatureRouting] = []
    weak var parentRouter: FeatureRouting?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        showSettings()
    }
    
    func showSettings() {
        let settingsView = SettingsView(
            onNotificationsTapped: { [weak self] in
                self?.showNotificationSettings()
            },
            onPrivacyTapped: { [weak self] in
                self?.showPrivacySettings()
            }
        )
        
        let viewController = UIHostingController(rootView: settingsView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showNotificationSettings() {
        let notificationView = NotificationSettingsView()
        let viewController = UIHostingController(rootView: notificationView)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    private func showPrivacySettings() {
        let privacyView = PrivacySettingsView()
        let viewController = UIHostingController(rootView: privacyView)
        navigationController.pushViewController(viewController, animated: true)
    }
}

// Example placeholder views
struct SettingsView: View {
    let onNotificationsTapped: () -> Void
    let onPrivacyTapped: () -> Void
    
    var body: some View {
        List {
            Button("Notifications", action: onNotificationsTapped)
            Button("Privacy", action: onPrivacyTapped)
        }
        .navigationTitle("Settings")
    }
}

struct NotificationSettingsView: View {
    var body: some View {
        Text("Notification Settings")
            .navigationTitle("Notifications")
    }
}

struct PrivacySettingsView: View {
    var body: some View {
        Text("Privacy Settings")
            .navigationTitle("Privacy")
    }
}