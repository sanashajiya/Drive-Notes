# Drive Notes

Drive Notes is a productivity-focused Flutter app that helps users effortlessly write, manage, and sync text notes to their personal *Google Drive*. The project follows clean architecture principles and uses **Riverpod** for state management, **GoRouter** for routing, **Hive** for offline storage, and the **Google Drive API** for cloud integration.

---

## 🚀 Getting Started

### 1. 📂 Clone the Project
To get a local copy up and running:
```bash
git clone https://github.com/sanashajiya/Drive-Notes.git
cd drive_notes
```

### 2. 📦 Install Packages
Install all necessary dependencies:
```bash
flutter pub get
```

### 3. 🔐 Google API Configuration

To enable integration with Google Drive:

---

#### ✅ Step 1: Access Google Cloud Console
- Navigate to [Google Cloud Console](https://console.cloud.google.com/)
- Sign in with your Google credentials

---

#### ✅ Step 2: Initialize a New Project
- Click the project selector at the top and choose *New Project*
- Set your project name (e.g., `DriveNotes`)
- Click *Create*

---

#### ✅ Step 3: Activate Required APIs
- Go to *APIs & Services > Library*
- Enable the following:
  - Google Drive API
  - Google People API

---

#### ✅ Step 4: Setup OAuth Consent Screen
- Navigate to *APIs & Services > OAuth consent screen*
- Choose *External* > Hit *Create*
- Provide:
  - App name (e.g., DriveNotes)
  - User support and developer email addresses
- Click *Save and Continue* until completion

---

#### ✅ Step 5: Generate OAuth Credentials for Android
- Go to the *Credentials* section
- Select *Create Credentials > OAuth client ID*
- Choose *Android* and enter:
  - Package name: `com.example.drive_notes`
  - SHA-1 fingerprint (generate using the command below):
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

---

#### ✅ Step 6: Add Test Accounts
- Return to the *OAuth consent screen*
- Scroll to the *Test users* section
- Add the Gmail accounts you intend to test with

---

### 4. ▶️ Launching the Application
Run the app on a connected device or emulator:
```bash
flutter run
```

---

## ✨ Key Highlights

- 🔐 Sign in with Google (OAuth 2.0)
- 📝 Create and modify notes, stored as `.txt` files on Drive
- 📁 All data saved in a custom `DriveNotes` folder in your Google Drive
- 🔄 Sync support with read, update, and delete capabilities
- 📡 Offline-friendly interface powered by Hive
- 🧱 Cleanly structured architecture using Riverpod and GoRouter

---

## ⚠️ Caveats

- Any edits made while offline require a manual refresh or re-login to sync with Drive

---

## 📁 Project Structure Overview

```
lib/
│
├── models/                  # Models like NoteFile
│
├── providers/              # Riverpod state managers
│   ├── auth_state_provider.dart
│   ├── file_state_notifier.dart
│   └── google_auth_provider.dart
│
├── screens/                # UI screens and widgets
│   ├── create_note_screen.dart
│   ├── edit_note_screen.dart
│   ├── welcome_screen.dart
│   └── widgets/
│       └── note_tile.dart
│
├── services/               # Backend services
│   ├── google_auth_service.dart
│   └── drive_service.dart
│
└── main.dart               # Entry point of the app
```

---

## 🧪 Testing the App

Run Flutter widget tests using:
```bash
flutter test
```

✅ Example: `NoteTile` widget has been widget tested for UI and logic.

---


