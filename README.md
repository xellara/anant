## Architecture Overview

The app is structured to support dynamic services, ensuring that different types of services (bike selling, hotel booking, etc.) can coexist and be added as the app grows. We use the **BLoC** pattern to separate business logic from the UI, making the app modular and testable.

### **File Structure**

```plaintext
lib/
├── blocs/                              # Contains all your BLoC logic (business logic)
│   ├── auth/                           # Authentication-related logic
│   │   ├── auth_bloc.dart              # Main auth BLoC
│   │   ├── auth_event.dart             # Auth events (login, logout, etc.)
│   │   ├── auth_state.dart             # Auth states (logged in, logged out, loading, error)
│   ├── global/                         # Global app-wide logic (state management)
│   │   ├── app_bloc.dart               # Global app BLoC (app loading, settings, etc.)
│   │   ├── app_event.dart              # Global events (app initialization, user preferences)
│   │   ├── app_state.dart              # Global app states (loading, error, ready)
│   ├── services/                       # Specific service-related BLoC logic (Bike, Hotel, etc.)
│   │   ├── bike/                       # Bike selling BLoC
│   │   │   ├── bike_bloc.dart          # Main BLoC for bike selling
│   │   │   ├── bike_event.dart         # Bike-specific events
│   │   │   ├── bike_state.dart         # Bike-specific states
│   │   ├── hotel/                      # Hotel booking BLoC
│   │   │   ├── hotel_bloc.dart         # Main BLoC for hotel bookings
│   │   │   ├── hotel_event.dart        # Hotel-specific events
│   │   │   ├── hotel_state.dart        # Hotel-specific states
│   │   ├── food_delivery/              # Food delivery BLoC
│   │   │   ├── food_delivery_bloc.dart # Main BLoC for food delivery
│   │   │   ├── food_delivery_event.dart# Food delivery-specific events
│   │   │   ├── food_delivery_state.dart# Food delivery-specific states
│   │   └── ...                         # Additional services like education, travel, etc.
├── models/                             # Contains models for different services and common entities
│   ├── user_model.dart                 # Model for user data
│   ├── bike_model.dart                 # Model for bike (selling) data
│   ├── hotel_model.dart                # Model for hotel (booking) data
│   ├── food_delivery_model.dart        # Model for food delivery data
│   ├── common_models.dart              # Common models (address, payment info, etc.)
│   └── ...                             # Other service-specific models
├── screens/                            # Contains the UI screens (pages) for all services
│   ├── auth/                           # Authentication screens (login, register, etc.)
│   │   ├── login_screen.dart
│   │   ├── register_screen.dart
│   │   ├── forgot_password_screen.dart
│   ├── home/                           # Home screen and service selection
│   │   ├── home_screen.dart            # Displays available services
│   │   ├── home_widgets.dart           # Widgets for home screen UI
│   ├── services/                       # Service-specific screens (Bike, Hotel, Food, etc.)
│   │   ├── bike/                       # Screens for bike selling services
│   │   │   ├── bike_listing_screen.dart  # List of available bikes
│   │   │   ├── bike_detail_screen.dart   # Detailed view of a bike for sale
│   │   ├── hotel/                      # Screens for hotel booking services
│   │   │   ├── hotel_listing_screen.dart # List of hotels available
│   │   │   ├── hotel_detail_screen.dart  # Detailed view of a hotel
│   │   ├── food_delivery/              # Screens for food delivery services
│   │   │   ├── food_listing_screen.dart  # List of food items or restaurants
│   │   │   ├── food_detail_screen.dart   # Detailed view of a food item or restaurant
│   │   └── ...                         # Screens for other services
│   └── global/                         # Common screens (settings, profile, etc.)
│       ├── settings_screen.dart
│       ├── profile_screen.dart
│       └── error_screen.dart           # Generic error screen for handling failures
├── widgets/                            # Common reusable widgets
│   ├── custom_button.dart              # Custom button widget
│   ├── custom_card.dart                # Custom card widget for displaying items
│   ├── service_card.dart               # Reusable widget for displaying service items (bike, hotel)
│   ├── loading_indicator.dart          # Reusable loading spinner widget
│   ├── error_widget.dart               # Reusable error widget to show errors
│   └── ...                             # Any other reusable widgets
├── services/                           # Handles external services (API, local storage, etc.)
│   ├── api_service.dart                # API client service to make network requests
│   ├── storage_service.dart            # Service to handle local storage (e.g., shared preferences)
│   ├── push_notification_service.dart  # Service for push notifications
│   └── ...                             # Other services like location, analytics, etc.
├── utils/                              # Utility classes and helpers (validation, constants, etc.)
│   ├── constants.dart                  # Constants used throughout the app (URLs, keys, etc.)
│   ├── validators.dart                 # Helper functions for validating inputs (email, password, etc.)
│   ├── date_helper.dart                # Helper for date formatting
│   ├── network_helper.dart             # Helper functions for network requests
│   └── ...                             # Other utility functions and helpers
├── main.dart                           # Main entry point for your app
└── routes.dart                         # Routing configuration for navigation (named routes)
