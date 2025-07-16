# Tree Hierarchy Router Architecture

## Overview

This architecture implements a tree-based coordinator pattern where each feature has its own router that manages navigation within that feature. Routers can have child routers for sub-features, creating a hierarchical navigation structure.

## Key Components

### 1. FeatureRouting Protocol
Base protocol that all routers implement:
- `navigationController`: The UINavigationController used for navigation
- `childRouters`: Array of child routers for sub-features
- `parentRouter`: Weak reference to parent router
- `start()`: Entry point to begin the feature's navigation flow

### 2. AppCoordinator
The root coordinator that:
- Creates the main UINavigationController
- Starts the initial feature router
- Manages the app window

### 3. Feature Routers
Each feature has its own router (e.g., `RestaurantRouter`, `ProfileRouter`):
- Manages navigation within the feature
- Creates and configures view controllers
- Handles navigation callbacks from views
- Can spawn child routers for sub-features

## Architecture Benefits

1. **Modularity**: Each feature's navigation is self-contained
2. **Scalability**: Easy to add new features without touching existing code
3. **Testability**: No singletons, all dependencies are injected
4. **Clear Hierarchy**: Parent-child relationships model navigation flow
5. **Flexibility**: Features can have their own navigation patterns

## Usage Example

```swift
// In RestaurantRouter
func showRestaurantList() {
    let presenter = RestaurantListPresenter()
    var view = RestaurantListView(presenter: presenter)
    
    // Navigation handled via callback
    view.onRestaurantSelected = { [weak self] restaurant in
        self?.showRestaurantDetail(restaurant: restaurant)
    }
    
    let viewController = UIHostingController(rootView: view)
    navigationController.setViewControllers([viewController], animated: false)
}
```

## Adding a New Feature

1. Create a new router conforming to `FeatureRouting`
2. Implement navigation methods for the feature
3. Add navigation callbacks to views
4. Integrate with parent router or AppCoordinator

## Router Hierarchy Example

```
AppCoordinator
├── RestaurantRouter
│   └── DealRouter (potential child)
├── ProfileRouter
│   └── SettingsRouter
│       ├── NotificationSettingsRouter
│       └── PrivacySettingsRouter
└── OrderRouter
    └── CheckoutRouter
```

## Migration from Old Router

The old monolithic router is still present but deprecated. New features should use the coordinator pattern, and existing features should be migrated incrementally.