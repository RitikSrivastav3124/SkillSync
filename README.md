# 🚀 SkillSync

SkillSync is a modern Flutter-based skill-sharing and networking platform that connects users based on their skills and interests.  
Built using Firebase & Provider with a clean Material 3 UI.

---

## ✨ Features

- 🔐 Firebase Authentication (Login / Register)
- 👤 User Profile Management
- 🎯 Skill-based Matching
- 🔄 Real-time Data with Firebase
- 🎨 Clean & Responsive UI
- 📱 Android Ready (APK Support)
- 🌗 Adaptive Design (Mobile / Tablet)

---

## 🛠 Tech Stack

- Flutter
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Provider (State Management)
- Google Fonts
- Material 3 Design

---

## 📂 Project Structure

```
lib/
│
├── providers/
│   └── auth_provider.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── auth_wrapper.dart
│   └── ...
│
├── utils/
│   └── api_key.dart (ignored)
│
└── main.dart
```

---

## 🔥 Getting Started

### 1️⃣ Clone the repository

```bash
git clone https://github.com/your-username/skillsync.git
cd skillsync
```

### 2️⃣ Install dependencies

```bash
flutter pub get
```

### 3️⃣ Setup Firebase

- Create project in Firebase Console
- Add Android app
- Download `google-services.json`
- Place inside:

```
android/app/google-services.json
```

### 4️⃣ Run the app

```bash
flutter run
```

---

## 📦 Build APK

```bash
flutter build apk --release
```

APK location:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## 🔐 Environment & Security

Sensitive files are ignored using `.gitignore`:

- `google-services.json`
- `api_key.dart`
- build files

---

## 🎨 App Theme

Primary Color: `#3F72AF`  
Font: Poppins  
Design: Material 3

---

## 👨‍💻 Author

Made with ❤️ using Flutter

---

## 📄 License

This project is licensed under the MIT License.

