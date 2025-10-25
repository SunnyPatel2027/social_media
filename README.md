# Social Media Flutter App

A simple, modern social media-style Flutter app built with **Firebase**, **BLoC (Cubit)**, and **GoRouter**.  
It allows users to **sign up, log in, post messages**, and view posts in **real time** — with a clean, production-ready architecture.

---

## Features

Firebase Authentication (Email/Password)  
Real-time Firestore Post Updates  
BLoC (Cubit) State Management  
GoRouter Navigation (No back after login/logout)  
Flutter Secure Storage for persistent sessions  
Centralized Error Handling & Common Models  
Global Loader & Splash Screen  
Proper Logout Handling (Single Tap, Safe Redirect)

---

## Architecture Overview

```
lib/
 ├── core/
 │    ├── constants/
 │    │    ├── app_colors.dart
 │    │    ├── route_names.dart
 │    │    └── app_constants.dart
 │    ├── error/
 │    │    ├── error_handler.dart
 │    │    └── failure.dart
 │    ├── widgets/
 │         ├── loading_widget.dart
 │         ├── common_snackbar.dart
 │         └── ...
 │
 ├── features/
 │    ├── auth/
 │    │    ├── cubit/ (AuthCubit, AuthState)
 │    │    ├── data/ (AuthRepository, UserModel)
 │    │    └── presentation/ (Login, Signup Screens)
 │    ├── post/
 │    │    ├── cubit/ (PostCubit, PostState)
 │    │    ├── data/ (PostRepository)
 │    │    └── presentation/ (PostScreen)
 │    └── splash/ (SplashScreen)
 │
 ├── app.dart
 └── main.dart
```

Clean, layered structure for **scalability** and **maintainability**.

---

## Firebase Setup

1. Create a new Firebase project from the [Firebase Console](https://console.firebase.google.com/).
2. Enable **Email/Password Authentication** under **Authentication → Sign-in methods**.
3. Enable **Cloud Firestore** (Start in test mode for development).
4. Download configuration files:
   - `google-services.json` → place in `android/app/`
   - `GoogleService-Info.plist` → place in `ios/Runner/`
5. Run configuration:
   ```bash
   flutterfire configure
   flutter pub get
   ```

---

## Run the App

To run the app on emulator or device:

```bash
flutter pub get
flutter run
```

To build the release APK:

```bash
flutter build apk --release
```

The APK will be generated at:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Download APK

[Click here to download the latest APK](./social_media_release.apk)

_(If uploaded via GitHub or Releases section)_

---

## How It Works

- When app starts → Splash screen checks login state.
- If user logged in → Redirects to Post Screen.
- If not → Redirects to Login Screen.
- On Post Screen → User can add posts (real-time Firestore updates).
- Logout → Redirects safely back to Login Screen, no double-taps or back navigation.

---

## Tech Stack

| Category             | Tools Used                                                   |
| -------------------- | ------------------------------------------------------------ |
| **Framework**        | Flutter (3.x+)                                               |
| **State Management** | BLoC (Cubit)                                                 |
| **Navigation**       | GoRouter                                                     |
| **Backend**          | Firebase (Auth + Firestore)                                  |
| **Storage**          | Flutter Secure Storage                                       |
| **Architecture**     | Clean Architecture (Core, Data, Domain, Presentation Layers) |

---

## Author

**Sunny Patel**  
Flutter Developer
sunnypatel@example.com  
[GitHub Profile](https://github.com/sunnypatel)

---
