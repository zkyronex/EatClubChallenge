# EatClub Challenge

iOS application built with SwiftUI for the EatClub coding challenge.

## Requirements

- Xcode 16.4+
- iOS 18.0+
- macOS 14.0+

## Getting Started

1. Clone the repository
2. Open `EatClubChallenge.xcodeproj` in Xcode
3. Select your target device/simulator
4. Build and run (⌘+R)

## Architecture

The project follows Clean Architecture with MVP (Model-View-Presenter) pattern:

- **Views**: SwiftUI components for UI
- **Presenters**: Business logic and state management
- **Fetchers**: Data layer for API/database operations
- **Router**: Navigation coordination

## Testing

Run tests using:
```bash
xcodebuild test -project EatClubChallenge.xcodeproj -scheme EatClubChallenge -destination 'platform=iOS Simulator,name=iPhone 16 Pro'
```

## License

© 2025 Jason Chan