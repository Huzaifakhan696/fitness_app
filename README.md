# Fitness App

A Flutter fitness tracking application built with Clean Architecture principles, featuring workout planning, mood tracking, and health insights.

## Dependencies Used & Why

### State Management
- **flutter_riverpod (^2.6.1)**: Used for state management throughout the app. Provides reactive state management with providers, allowing for efficient data flow and UI updates. Essential for managing dynamic data like selected dates, workout plans, mood values, and hydration levels.

### Utilities
- **intl (^0.19.0)**: Used for date and time formatting. Enables proper localization and formatting of dates (e.g., "Today, 22 Dec 2024", weekday names) across different locales.
- **google_fonts (^6.2.1)**: Used to load and apply custom fonts (Mulish) throughout the application. Provides consistent typography matching the design specifications with various font weights (Regular, Medium, SemiBold, Bold).

### Navigation
- **go_router (^14.2.7)**: Used for declarative routing and navigation. Provides type-safe navigation with named routes, making it easy to navigate between screens (Home, Plan/Training Calendar, Mood, Profile) and handle deep linking.

### UI Components
- **cupertino_icons (^1.0.8)**: Provides iOS-style icons for use in the application, offering a consistent icon set across platforms.

## Project Structure

The project follows Clean Architecture principles with a clear separation of concerns:

```
lib/
├── assets/                          # Image assets and icons
│   ├── home_navbar_assests/         # Bottom navigation bar icons
│   ├── home_screen_assets/          # Home screen icons (bell, sun, week, etc.)
│   ├── mood_screen_assets/          # Mood screen emotion images
│   └── training_screen_assets/      # Training calendar icons (drag icon)
│
├── core/                            # Shared/core functionality
│   ├── router/                      # Navigation configuration
│   │   └── app_router.dart         # GoRouter setup with route definitions
│   └── widgets/                      # Reusable widgets
│       ├── bottom_nav_bar.dart      # Shared bottom navigation bar
│       └── radial_config_background.dart  # Custom gradient background widget
│
├── presentation/                     # UI layer (screens and widgets)
│   ├── home/                        # Home screen feature
│   │   ├── home_screen.dart         # Main home screen with workouts, insights, hydration
│   │   └── widgets/                 # Home screen specific widgets
│   │       ├── week_calendar.dart   # Weekly calendar widget
│   │       ├── workout_card.dart    # Workout display card
│   │       ├── insight_card.dart    # Calories/weight insight cards
│   │       └── hydration_card.dart  # Hydration tracking card
│   │
│   ├── mood/                        # Mood tracking feature
│   │   ├── mood_screen.dart         # Mood selection screen
│   │   └── widgets/
│   │       └── mood_circle.dart     # Interactive mood circle widget
│   │
│   └── training_calendar/           # Training calendar feature
│       └── training_calendar_screen.dart  # Workout planning calendar with drag & drop
│
└── main.dart                        # Application entry point
```

### Directory Purposes

- **assets/**: Contains all image assets organized by feature/screen. Includes navigation icons, screen-specific icons, mood images, and training calendar assets.

- **core/**: Contains shared functionality used across the entire application:
  - **router/**: Centralized navigation configuration using GoRouter
  - **widgets/**: Reusable UI components that can be used in multiple screens (e.g., bottom navigation bar, gradient backgrounds)

- **presentation/**: Contains all UI-related code organized by feature:
  - Each feature (home, mood, training_calendar) has its own directory
  - Each feature directory contains the main screen file and a `widgets/` subdirectory for feature-specific widgets
  - This structure makes it easy to locate and maintain code related to specific features

- **main.dart**: Application entry point that initializes the ProviderScope (for Riverpod) and sets up the MaterialApp with GoRouter.


## Features

- **Home Screen**: Displays daily workouts, health insights (calories, weight), and hydration tracking
- **Training Calendar**: Interactive calendar for planning and organizing workouts with drag-and-drop functionality
- **Mood Tracking**: Visual mood selection interface with circular indicator
- **Dynamic Data**: All data is managed reactively using Riverpod providers
- **Custom Styling**: Consistent typography using Mulish font family with specific weights and sizes

## App Screenshots

View screenshots of the app showcasing the main features and UI:

[View Screenshots](https://drive.google.com/drive/folders/1HT1k3HYTBpmagpj4CglstlY4HaDQAs0p?usp=drive_link)

## App Video

Watch a short video demonstration of the app showing the app's flow and functionality:

[Watch App Demo Video](https://drive.google.com/drive/folders/1aL_bgglQx9lFQTQTFo6QE7Ukk_fV_nY8?usp=drive_link)

## App APK

Download the APK file to test the app on Android devices:

[Download APK](https://drive.google.com/drive/folders/1aL_bgglQx9lFQTQTFo6QE7Ukk_fV_nY8?usp=drive_link)

## Architecture

The app follows Clean Architecture principles:
- **Presentation Layer**: UI screens and widgets (in `presentation/`)
- **Core Layer**: Shared utilities, routing, and reusable widgets (in `core/`)
- **State Management**: Riverpod providers for reactive state management
- **Navigation**: Declarative routing with GoRouter
