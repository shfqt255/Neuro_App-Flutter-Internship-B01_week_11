# Flutter Maps & Location Services

A collection of four Flutter applications built as part of Week 11 coursework, covering Google Maps integration, Places search and autocomplete, directions and routing, and geofencing with location tracking.

---

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Applications](#applications)
  - [maps\_app — Google Maps Integration](#maps_app--google-maps-integration)
  - [places\_app — Places Search & Autocomplete](#places_app--places-search--autocomplete)
  - [directions\_app — Directions & Routes](#directions_app--directions--routes)
  - [geofence\_app — Geofencing & Location Tracking](#geofence_app--geofencing--location-tracking)
- [API Key Setup](#api-key-setup)
- [Permissions](#permissions)
- [Dependencies](#dependencies)
- [Running the Apps](#running-the-apps)
- [Notes](#notes)

---

## Overview

This repository contains four standalone Flutter applications demonstrating real-world usage of location-based services on Android and iOS. Each application is self-contained within its own directory and can be run independently.

| App | Focus | Estimated Build Time |
|---|---|---|
| maps\_app | Core map display, markers, clustering | 5 hours |
| places\_app | Places API, autocomplete, nearby search | 4 hours |
| directions\_app | Routing, polylines, navigation steps | 5 hours |
| geofence\_app | Geofencing, background tracking, notifications | 4 hours |

---

## Prerequisites

Before running any of the applications, ensure the following are in place:

- Flutter SDK 3.x or later
- Dart 3.x or later
- Android Studio or Xcode (or both, for cross-platform testing)
- A Google Cloud Console project with billing enabled
- The following APIs enabled in Google Cloud Console:
  - Maps SDK for Android
  - Maps SDK for iOS
  - Places API
  - Directions API
  - Geocoding API

---


## Applications

### maps\_app — Google Maps Integration

Displays an interactive Google Map with full location awareness and marker management.

**Features:**
- Full-screen Google Map with configurable initial camera position
- Current location detection using the `geolocator` package
- Blue dot indicator showing the user's real-time position
- Custom markers using `BitmapDescriptor` for tailored visual styles
- Marker clustering to handle dense map areas cleanly
- Tap-to-add-marker functionality storing markers in a `Set<Marker>`
- `GoogleMapController` for programmatic camera movement

**Key Packages:**
```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  geolocator: ^10.0.0
```

**Setup:**
1. Add your API key to `android/app/src/main/AndroidManifest.xml`:
   ```xml
   <meta-data
     android:name="com.google.android.geo.API_KEY"
     android:value="YOUR_API_KEY"/>
   ```
2. Add your API key to `ios/Runner/AppDelegate.swift`:
   ```swift
   GMSServices.provideAPIKey("YOUR_API_KEY")
   ```

---

### places\_app — Places Search & Autocomplete

Implements a full place search experience using the Google Places API, with autocomplete suggestions and nearby place discovery.

**Features:**
- Search `TextField` with real-time autocomplete powered by `queryAutocomplete()`
- Suggestions displayed in a scrollable `ListView`
- Place detail retrieval using `details()` to extract coordinates
- Camera navigation to the selected place with a placed marker
- Nearby places search using `nearbySearch()` with results shown in a list

**Key Packages:**
```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  google_place: ^0.9.0
```

**Setup:**
1. Enable the Places API in Google Cloud Console.
2. Initialize `GooglePlace` with your API key in the app entry point:
   ```dart
   final googlePlace = GooglePlace("YOUR_API_KEY");
   ```

---

### directions\_app — Directions & Routes

Fetches and renders directions between two locations, drawing a polyline on the map and displaying route metadata and step-by-step instructions.

**Features:**
- Origin and destination marker selection on the map
- Directions fetched from the Google Directions API
- Polyline decoding using `flutter_polyline_points` and rendered as a `Polyline` widget
- Distance and estimated travel duration displayed to the user
- Step-by-step navigation instruction list
- Active step highlighting as the user progresses

**Key Packages:**
```yaml
dependencies:
  google_maps_flutter: ^2.5.0
  flutter_polyline_points: ^2.0.0
  http: ^1.1.0
```

**Usage:**
1. Tap the map to set the origin point.
2. Tap again to set the destination.
3. The route is drawn automatically and metadata is shown in the bottom panel.
4. Scroll through the instruction list to view each navigation step.

---

### geofence\_app — Geofencing & Location Tracking

Defines virtual boundaries around geographic locations and responds to entry and exit events with local notifications and persistent location history.

**Features:**
- Circular geofence definition with configurable center coordinates and radius
- `GeofenceManager` class encapsulating registration and event handling
- `onEnter` and `onExit` callbacks for geofence boundary events
- Local push notifications triggered on geofence events
- Location history stored persistently in a local database
- Background location tracking with battery optimization handling
- Designed for reliable geofence triggering on both Android and iOS

**Key Packages:**
```yaml
dependencies:
  geofence_service: ^4.0.0
  flutter_local_notifications: ^16.0.0
  sqflite: ^2.3.0
  geolocator: ^10.0.0
```

**Android Setup:**

Add the following to `AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
```

**iOS Setup:**

Add the following keys to `Info.plist`:
```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app requires background location access for geofencing.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app uses your location to detect geofence boundaries.</string>
<key>UIBackgroundModes</key>
<array>
  <string>location</string>
</array>
```

---

## API Key Setup

All four applications require a valid Google Maps API key. It is strongly recommended to use separate keys per application and to restrict each key to the specific APIs and platforms it requires.

**Steps to obtain an API key:**

1. Go to [Google Cloud Console](https://console.cloud.google.com).
2. Create a new project or select an existing one.
3. Navigate to APIs & Services > Credentials.
4. Click Create Credentials > API Key.
5. Under API restrictions, enable only the APIs required for the target application.
6. Under Application restrictions, restrict to Android or iOS as appropriate.

**Security notice:** Do not commit raw API keys to version control. Use environment variables, a `.env` file excluded via `.gitignore`, or Flutter's `--dart-define` flag to inject keys at build time.

---

## Permissions

The following permissions are required across the applications. Each app only requests what it needs.

**Android (`AndroidManifest.xml`):**
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/>
<uses-permission android:name="android.permission.FOREGROUND_SERVICE"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
```

**iOS (`Info.plist`):**
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Location access is required to show your position on the map.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>Background location is required for geofencing features.</string>
```

---

## Dependencies

Below is a consolidated list of all packages used across the four applications.

| Package | Version | Used In |
|---|---|---|
| google\_maps\_flutter | ^2.5.0 | all apps |
| geolocator | ^10.0.0 | maps\_app, geofence\_app |
| google\_place | ^0.9.0 | places\_app |
| flutter\_polyline\_points | ^2.0.0 | directions\_app |
| geofence\_service | ^4.0.0 | geofence\_app |
| flutter\_local\_notifications | ^16.0.0 | geofence\_app |
| sqflite | ^2.3.0 | geofence\_app |
| http | ^1.1.0 | directions\_app |
| permission\_handler | ^11.0.0 | all apps |

---

## Running the Apps

Each application is independent. Navigate into the desired app directory and run it using the Flutter CLI.

```bash
# Example: running maps_app
cd maps_app
flutter pub get
flutter run
```

Repeat the same steps for `places_app`, `directions_app`, and `geofence_app`.

**Recommended test environment:**

- A physical device is strongly preferred over an emulator for all location-based features.
- For geofencing tests, use a device with GPS enabled and walk or drive through the defined boundary coordinates, or use GPS spoofing tools during development.
- Background location tracking on iOS requires the app to be tested on a real device; simulators do not support background location.

---

## Notes

- The Google Directions API returns encoded polylines. The `flutter_polyline_points` package handles decoding. Ensure the Directions API is enabled in Google Cloud Console before testing `directions_app`.
- Geofence accuracy varies by device hardware and OS version. Android devices with battery optimization enabled may delay or suppress geofence events. Guide users to exempt the app from battery optimization in device settings.
- The Places API has usage quotas and pricing tiers. Monitor usage in Google Cloud Console to avoid unexpected charges during development.
- On Android 10 and above, `ACCESS_BACKGROUND_LOCATION` must be requested separately and will direct the user to system settings to grant it. Handle this flow gracefully in the UI.
- All four apps were developed and tested against Flutter 3.x. Compatibility with earlier versions is not guaranteed.

---

## License

This project is intended for educational purposes as part of a Flutter mobile development course. Refer to the individual application directories for any additional licensing information.
