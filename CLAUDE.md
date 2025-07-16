# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an iOS application built with SwiftUI for the EatClub coding challenge. The project uses Xcode 16.4 and targets iOS 18.5+.

## Common Development Commands

### Building and Running
- **Open in Xcode**: `open EatClubChallenge.xcodeproj`
- **Build from command line**: `xcodebuild -project EatClubChallenge.xcodeproj -scheme EatClubChallenge -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build`
- **Run tests**: `xcodebuild test -project EatClubChallenge.xcodeproj -scheme EatClubChallenge -destination 'platform=iOS Simulator,name=iPhone 16 Pro'`
- **Clean build**: `xcodebuild -project EatClubChallenge.xcodeproj -scheme EatClubChallenge clean`

### Testing
The project uses Apple's new Swift Testing framework (not XCTest). Tests are located in:
- `EatClubChallengeTests/` - Unit tests
- `EatClubChallengeUITests/` - UI tests

To run specific tests:
```bash
xcodebuild test -project EatClubChallenge.xcodeproj -scheme EatClubChallenge -only-testing:EatClubChallengeTests/SpecificTestClass/testMethod
```

## Architecture and Code Structure

### Clean Architecture with MVP Pattern
The project implements Clean Architecture using Model-View-Presenter (MVP) pattern with the following structure:

```
EatClubChallenge/
├── Core/
│   ├── Models/           # Domain models
│   ├── APIService/       # Generic networking layer
│   └── Extensions/       # Shared extensions
├── Features/
│   └── [FeatureName]/
│       ├── Models/       # Feature-specific models
│       ├── Views/        # SwiftUI views
│       ├── Presenters/   # Business logic and state management
│       └── Fetchers/     # Data fetching implementation
├── Router/
│   ├── Router.swift      # Navigation coordinator
│   └── Routes.swift      # Route definitions
├── Resources/
│   ├── Localization/     # String catalogs
│   ├── Fonts/           # Custom fonts (if any)
│   └── Colors/          # Color assets
└── App/
    └── EatClubChallengeApp.swift

```

### Architecture Layers

1. **View Layer** (SwiftUI Views)
   - Pure UI components wrapped in UIHostingController
   - Receives state from Presenter via Combine publishers
   - Sends user actions to Presenter

2. **Presenter Layer**
   - Implements business logic
   - Manages view state using Combine
   - Coordinates with Fetcher for data operations
   - Protocol-based for testability

3. **Fetcher Layer**
   - Implementation detail layer
   - Handles data fetching logic
   - Transforms API responses to domain models
   - Can implement caching, local storage

4. **APIService Layer**
   - Generic networking implementation
   - JSON decoding with Codable
   - Centralized error handling
   - Returns Combine publishers

### Router Pattern Implementation
```swift
// Views are wrapped in UIHostingController for navigation
let view = FeatureView()
let presenter = FeaturePresenter()
view.presenter = presenter
let hostingController = UIHostingController(rootView: view)
router.navigate(to: .feature(hostingController))
```

### Combine Data Flow
- Use `@Published` properties in Presenters
- Views subscribe using `onReceive` or `@ObservedObject`
- Network requests return `AnyPublisher<T, Error>`
- Use operators like `map`, `flatMap`, `catch` for data transformation

### Project Configuration
- **Bundle ID**: `com.jasonchan.eatclubchallenge.EatClubChallenge`
- **Minimum iOS**: 18.5 (beta)
- **Swift Version**: 5.0
- **UI Framework**: SwiftUI only (no UIKit)

## Important Notes

1. **iOS 18.5 Requirement**: This project targets iOS 18.5, which is a very recent/beta version. Ensure any APIs used are available in this version.

2. **No External Dependencies**: The project currently has no Swift Package Manager, CocoaPods, or Carthage dependencies. If adding dependencies, use Swift Package Manager via Xcode.

3. **Swift Testing Framework**: The project uses the new Swift Testing framework (with `@Test` macro) instead of XCTest. When writing tests, use the modern Swift Testing syntax.

4. **Code Signing**: Automatic code signing is enabled. The development team is set to Jason Chan (4V7NY686Y7).

## UI Infrastructure

### Color Scheme
Implement a color palette extension that supports both light and dark modes:

```swift
// Core/Extensions/Color+Palette.swift
extension Color {
    static let primary = Color("Primary")
    static let secondary = Color("Secondary")
    static let background = Color("Background")
    static let surface = Color("Surface")
    static let error = Color("Error")
    static let onPrimary = Color("OnPrimary")
    static let onSecondary = Color("OnSecondary")
    static let onBackground = Color("OnBackground")
    static let onSurface = Color("OnSurface")
    static let onError = Color("OnError")
}
```

Define colors in Assets.xcassets with light/dark variants for automatic mode switching.

### Typography System
Implement a font scheme that supports Dynamic Type for accessibility:

```swift
// Core/Extensions/Font+Typography.swift
extension Font {
    static let largeTitleFont = Font.system(.largeTitle)
    static let titleFont = Font.system(.title)
    static let headlineFont = Font.system(.headline)
    static let bodyFont = Font.system(.body)
    static let calloutFont = Font.system(.callout)
    static let footnoteFont = Font.system(.footnote)
    static let captionFont = Font.system(.caption)
}
```

### Localization
Use modern String Catalogs (.xcstrings) for internationalization:

1. Add `Localizable.xcstrings` to Resources/Localization/
2. Use String(localized:) for SwiftUI views:
   ```swift
   Text(String(localized: "welcome.message"))
   ```
3. Support multiple languages by adding translations in the String Catalog

## Key Development Considerations

### MVP Implementation Guidelines
- **Views**: Keep them dumb, only UI logic
- **Presenters**: All business logic, state management, and coordination
- **Fetchers**: Hide implementation details (network, cache, database)
- **Models**: Plain data structures, no business logic

### Combine Best Practices
- Use `@Published` for observable state in Presenters
- Prefer `AnyPublisher` return types for public APIs
- Handle errors with `.catch` and provide fallback values
- Use `.store(in: &cancellables)` for subscription management
- Leverage operators: `map`, `flatMap`, `combineLatest`, `merge`

### Router Navigation
- All navigation goes through Router
- Views don't know about other views
- Use dependency injection for Presenter creation
- Support both push and modal presentation styles

### Testing Strategy
- Unit test Presenters with mocked Fetchers
- Unit test Fetchers with mocked APIService
- UI test critical user flows
- Use protocols for all dependencies to enable mocking