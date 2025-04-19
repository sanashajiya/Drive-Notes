# 📘 Drive Notes

Drive Notes is a lightweight and powerful Flutter app designed to help users write, manage, and sync text notes directly to their Google Drive. It follows clean architecture principles and uses **Riverpod** for state management, **GoRouter** for navigation, **Hive** for offline persistence, and **Google Drive API** for cloud integration.

---

## 🚀 Getting Started

### 1. 📂 Clone the Project
```bash
git clone https://github.com/sanashajiya/Drive-Notes.git
cd drive-notes
```

### 2. 📦 Install Dependencies
```bash
flutter pub get
```

### 3. 🔐 Configure Google API

#### ✅ Step 1: Open Google Cloud Console
- Go to [Google Cloud Console](https://console.cloud.google.com/)
- Log in and create a new project

#### ✅ Step 2: Enable APIs
- Go to *APIs & Services > Library*
- Enable:
  - Google Drive API
  - Google People API

#### ✅ Step 3: Setup OAuth Consent Screen
- Navigate to *OAuth consent screen*
- Choose *External*, fill out app details
- Click through and save

#### ✅ Step 4: Create OAuth Credentials
- Go to *Credentials > Create Credentials > OAuth client ID*
- Choose **Android** and enter:
  - Package name: `com.example.note_sync`
  - SHA-1 fingerprint:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### ✅ Step 5: Add Test Users
- Under *OAuth consent screen > Test users*, add Gmail addresses

---

### 4. ▶️ Run the App
```bash
flutter run
```

---

## ✨ Features

- 🔐 Google Sign-In via OAuth
- 📝 Create, edit, and delete `.txt` notes synced with Drive
- ☁️ Custom `DriveNotes` folder in Drive
- 🛜 Works offline with auto-sync when back online
- 🧱 Follows Clean Architecture + Riverpod

---

## ❗ Known Limitations

### ⚠️ Offline Functionality
- Only the **Main Screen** (list of notes) is available in offline mode  
- **Create, edit, and delete** operations are **disabled** when offline  
- Notes are visible offline **only if they were previously loaded while online**

### 🔐 Google API Access
- The app is restricted to **test users** added through the **Google Cloud Console**  


---

## 🧭 Project Structure

```bash
lib/
│
├── models/                      # Data models
│   ├── note_model.dart
│   └── note_model.g.dart
│
├── providers/                  # State management with Riverpod
│   ├── auth_google_provider.dart
│   ├── auth_state_provider.dart
│   └── entry_state_notifier.dart
│
├── screens/                    # Screens and widgets
│   ├── widgets/
│   │   └── entry_card.dart
│   ├── add_new_entry.dart
│   ├── modify_entry_screen.dart
│   ├── main_screen.dart
│   └── intro_screen.dart
│
├── services/                   # Business logic / integrations
│   ├── auth_google_service.dart
│   └── cloud_drive_helper.dart
│
└── main.dart                   # App entry point
```

---

## 🧪 Testing

Run basic tests with:
```bash
flutter test
```

Widget examples like `EntryCard` are tested for UI/logic integrity.

---



