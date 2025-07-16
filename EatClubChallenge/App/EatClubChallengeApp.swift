//
//  EatClubChallengeApp.swift
//  EatClubChallenge
//
//  Created by Jason Chan on 16/7/2025.
//

import SwiftUI
import UIKit

@main
struct EatClubChallengeApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

struct RootView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let navigationController = UINavigationController()
        AppRouter.shared.configure(with: navigationController)
        
        // Set initial route
        if let router = AppRouter.shared.current {
            router.navigate(to: .restaurantList)
        }
        
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {
        // No updates needed
    }
}
