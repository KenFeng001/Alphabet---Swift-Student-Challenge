# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Alphabet Challenge** is a SwiftUI-based iOS app created for the Swift Student Challenge 2025. It's a gamified photography app that encourages users to find and photograph alphabet letters hidden in everyday scenes.

### Core Architecture

- **SwiftUI + SwiftData**: Modern iOS architecture using SwiftUI for UI and SwiftData for persistence
- **MVVM Pattern**: Uses `@Observable` classes and `@Model` data objects
- **Component-Based Structure**: UI components are modularized in the `Component/` directory
- **Separation of Concerns**: Clear separation between Views, Models, and Components

### Key Technologies

- **SwiftData**: For data persistence (PhotoItem and PhotoCollection models)
- **AVFoundation**: Camera functionality with live preview and high-quality capture
- **PhotosUI**: Image selection and saving capabilities
- **SwiftUI Animations**: Advanced scrolling and sliding card animations

## Project Structure

```
Alphabet/
├── AlphabetApp.swift          # Main app entry point with SwiftData setup
├── Views/                     # Main application views
│   ├── ContentView.swift      # Root view with tab navigation
│   ├── CollectionView.swift   # Collection management interface
│   ├── ViewfinderView.swift   # Camera interface
│   └── [other views]
├── Component/                 # Reusable UI components
│   ├── SlidingCards.swift     # Main sliding card interface
│   ├── Card.swift             # Individual letter cards
│   ├── LetterGrid.swift       # Grid layout for letters
│   └── [other components]
└── Model/                     # Data models and business logic
    ├── Data.swift             # Core SwiftData models (PhotoItem, PhotoCollection)
    ├── DataModel.swift        # Camera data handling
    ├── Camera.swift           # AVFoundation camera wrapper
    └── SampleData.swift       # Sample data for development
```

## Development Commands

This project uses Xcode for development. Since no Xcode project file exists in the current state:

- **Build**: Use Xcode to build the project
- **Run**: Use Xcode simulator or connected device
- **Test**: Run unit tests in `AlphabetTests/` and UI tests in `AlphabetUITests/`

## Key Data Models

### PhotoCollection
- Represents a themed collection of alphabet photos
- Tracks progress (collected letters out of 26)
- Has completion logic and time-based challenges
- Contains multiple `PhotoItem` objects

### PhotoItem  
- Individual photographed letter
- Contains image data, letter identification, and timestamp
- Can be "pinned" as the preferred version for a letter
- Belongs to a `PhotoCollection`

## Important Implementation Notes

### Camera Integration
- `DataModel.swift` handles camera preview and photo capture
- Uses async/await patterns for camera stream handling
- Photo data includes both full resolution and thumbnail images

### Sample Data Setup
- App automatically imports sample data on first launch
- Multiple sample collections (SampleData, SampleData0, SampleData2) are loaded
- Uses UserDefaults to track first launch state

### UI Architecture
- Uses tab-based navigation between "Find" and "Collection" modes
- Selected collection ID is maintained at the root level
- Heavy use of SwiftUI's `@State`, `@Query`, and `@Observable` patterns

## Development Considerations

- The app contains Chinese comments in some files (particularly `AlphabetApp.swift`)
- No existing project configuration files (removed from git)
- Focus on maintaining the sliding card animation performance
- Ensure proper SwiftData relationship handling between PhotoItem and PhotoCollection
- Camera permissions and AVFoundation setup are critical for core functionality