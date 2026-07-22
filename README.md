# TaskFlow - Production-Ready To-Do Management Application

![Flutter Version](https://img.shields.io/badge/Flutter-Latest_Stable-02569B?logo=flutter)
![Dart Version](https://img.shields.io/badge/Dart-3.6+-0175C2?logo=dart)
![Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-4CAF50)
![State Management](https://img.shields.io/badge/State_Management-BLoC-1976D2)
![Database](https://img.shields.io/badge/Database-Cloud_Firestore-FFCA28?logo=firebase)

## 📌 Project Overview
**TaskFlow** is a robust, production-grade Flutter application built for seamless task and to-do management. 

Developed as part of a Senior Flutter Developer Technical Assessment, this project demonstrates mastery over advanced Flutter development concepts. It goes beyond a simple CRUD app by integrating strict **Clean Architecture**, reactive **BLoC State Management**, **Firebase Authentication**, real-time **Cloud Firestore** synchronization, and highly optimized UI/UX patterns using **Material 3**.

The goal of this project is to showcase clean, scalable, and maintainable code that adheres to industry best practices, making it ready for production environments.

---

## ✨ Features

TaskFlow encompasses a comprehensive suite of features, all fully wired and functional.

### 🔐 Authentication
- **Login / Register**: Secure email and password authentication.
- **Forgot Password**: Password reset email flow.
- **Logout**: Safe session termination with confirmation dialogs.
- **Session Persistence**: Automatic routing based on persistent Firebase authentication state.

### 📋 Task Management
- **Create Task**: Add tasks specifying Title, Description, Priority (Low, Medium, High), Status (To Do, In Progress, Completed), and Due Date.
- **Edit Task**: Reusable form pre-filled with existing task data, updating modification timestamps dynamically.
- **Delete Task**: Safe task deletion with a Material 3 modal confirmation dialog.
- **Task Details Screen**: *(Future enhancement targeted)*
- **Change Task Status**: Interactive dropdown directly on the Task Card to change status without opening the edit screen.
- **Realtime Synchronization**: Firestore stream subscriptions automatically push live updates to the UI across all authenticated devices.

### 🔍 Search & Filtering
- **Search by Title**: Instant search functionality.
- **Debounced Search**: 350ms debounce on keystrokes to optimize performance and prevent rapid, unnecessary rebuilds.
- **Status Filter**: Filter tasks by their current progress state.
- **Priority Filter**: Filter tasks by their urgency level.
- **Clear Filters**: One-tap reset to remove all active searches, filters, and sorts.

### 🔃 Sorting & Refresh
- **Sort by Due Date**: Chronological sorting (null-safe, pushing tasks without due dates to the bottom).
- **Sort by Created Date**: Reverse chronological sorting (newest first).
- **Pull-to-Refresh**: Resets all filters and cleanly re-establishes the Firestore realtime subscription.

### 🛡️ Validation
- **Required Fields**: Strict form validation for title and description.
- **Character Limits**: Maximum 100-character limit on the title field with live counter and UI feedback.
- **Date Validation**: Custom `DueDatePickerField` explicitly prevents selection of past dates in both the picker UI and the form validator.
- **Feedback Messages**: Clear, user-friendly error messages on form submission failures.

### 🎨 UI / UX
- **Material 3 Design**: Vibrant color system, custom typography, and responsive touch feedback.
- **Responsive Layouts**: Constrained layouts that adapt gracefully to varying screen widths.
- **Dark & Light Themes**: Full custom implementations for both modes.
- **Theme Persistence**: Hive-backed local storage remembers user theme preferences across app restarts.
- **Animations**:
  - **Splash Animation**: Smooth fade and slide entrance.
  - **Animated Avatar**: A continuous, subtle pulsing glow effect.
  - **Welcome Animation**: A friendly 👋 hand wave (exactly 3 cycles before resting).
  - **Notification Slide**: Custom top-anchored animated snackbars for success/error feedback.
  - **Filter Capsules**: Animated physical transitions when toggling filter states.

### ⚡ Performance & Code Quality
- **In-Memory Filtering**: Blazing fast search and sort operations performed client-side on the active stream payload.
- **Optimized BLoC Rebuilds**: Strategic use of `buildWhen` to prevent unnecessary widget tree rebuilds.
- **Zero Static Analysis Issues**: `flutter analyze` returns absolutely 0 issues.
- **Cleaned Codebase**: Complete removal of dead template code, unused packages, and unused widgets.
- **Proper Lifecycles**: Strict adherence to `initState` and `dispose` for all `AnimationController`, `TextEditingController`, and `StreamSubscription` objects.
- **ThemeBloc Singleton**: Restructured to ensure global state reliability.

---

## 🛠️ Tech Stack

| Technology / Package | Purpose |
|----------------------|---------|
| **Flutter / Dart** | Core Framework |
| **flutter_bloc** | Predictable, reactive State Management |
| **get_it** | Dependency Injection & Service Locator |
| **firebase_auth** | User Identity & Authentication |
| **cloud_firestore** | NoSQL Database & Realtime Sync |
| **hive / hive_flutter**| Fast Local Storage (Theme persistence) |
| **equatable** | Value Equality for Bloc states/events |
| **intl** | Date formatting |

---

## 🏗️ Project Structure & Architecture

This project strictly adheres to **Clean Architecture**, dividing responsibilities into distinct layers to ensure maximum testability, maintainability, and scalability.

```text
lib/
├── config/                  # App constants, themes, & routing map
├── core/                    # Shared utilities, generic failures, custom UI widgets
├── di.dart                  # Dependency Injection (GetIt) setup
└── features/
    ├── authentication/      # Authentication Feature
    └── tasks/               # Tasks Feature
        ├── data/            # [DATA LAYER]
        │   ├── datasources/ # TaskRemoteDataSource (Firestore API calls)
        │   ├── models/      # TaskModel (JSON/Firestore serialization)
        │   └── repositories/# TaskRepositoryImpl (Data logic implementation)
        │
        ├── domain/          # [DOMAIN LAYER]
        │   ├── entities/    # TaskEntity (Pure Dart models, Enums)
        │   ├── repositories/# Abstract TaskRepository contract
        │   └── usecases/    # GetTasks, AddTask, UpdateTask, DeleteTask 
        │
        └── presentation/    # [PRESENTATION LAYER]
            ├── bloc/        # TaskBloc, TaskEvent, TaskState
            ├── pages/       # HomePage, AddTaskPage, EditTaskPage
            └── widgets/     # Modular UI (Cards, Forms, Pickers, Dialogs)
```

### 🔄 Architectural Flow
1. **UI (Widgets/Pages)** dispatch an `Event` to the **Bloc**.
2. **Bloc** receives the event and calls a **Use Case** from the Domain layer.
3. The **Use Case** enforces business rules and requests data from the abstract **Repository**.
4. The **Repository Implementation** (Data layer) decides whether to fetch data from a local cache or a **Remote Data Source**.
5. The **Remote Data Source** interacts directly with **Firebase** and maps the response into a Data Model.
6. The Data Model is cast to a pure Domain Entity and passed back up the chain.
7. The **Bloc** yields a new `State`, causing the **UI** to rebuild efficiently.

---

## 🧠 State Management (BLoC)

**BLoC (Business Logic Component)** was chosen for its strict separation of concerns, predictability, and excellent trace-ability in complex applications. 

- **TaskBloc**: Manages a continuous `StreamSubscription` to Firestore. It receives realtime snapshots, applies the current search/filter/sort parameters in-memory, and emits a `TaskLoaded` state.
- **AuthBloc**: Manages authentication events (Login, Register, Logout) and delegates to Use Cases.
- **ThemeBloc**: Registered as a Lazy Singleton to manage global dark/light mode state, persisting the choice locally via Hive.

---

## 🔥 Firebase & Security

### Firebase Authentication
Handles all user authentication safely using Firebase Auth SDK, providing persistent user sessions across app launches.

### Firestore Realtime Streams
Tasks are not merely fetched once; they are streamed. Any updates made in Firestore directly push down to the `TaskBloc` and update the UI instantaneously.

### Firestore Data Isolation
User data is strictly isolated. The `TaskRemoteDataSource` enforces that all queries scope specifically to the authenticated user's ID:
`users/{uid}/tasks/{taskId}`

### Security Rules (`firestore.rules`)
Production-grade security rules ensure that unauthorized access is impossible, even if the client app is compromised.
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} { allow read, write: if false; } // Default Deny All
    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## 🏎️ Performance Decisions
- **Debounced Searching**: A custom `Debouncer` class delays the search execution by 350ms, preventing the BLoC from rapidly filtering data while the user is actively typing.
- **In-Memory Filtering**: Instead of querying Firestore for every filter/sort change (which costs network time and Firebase quota), the app streams the user's entire task collection and performs blazing-fast localized sorting/filtering in-memory.
- **Stream Subscription Management**: Realtime streams are explicitly managed and closed when the Bloc is disposed, preventing memory leaks and zombie listeners.
- **Exception Mapping**: Transient Firebase errors (`SocketException`, `FirebaseAuthException`) are caught at the Data Source, passed up as custom exceptions, and elegantly mapped to clean `Failure` objects by the Repository.

---

## 🚀 Installation & Setup

### 1. Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.6+ recommended)
- Firebase Project configured for Android (`google-services.json`) & iOS (`GoogleService-Info.plist`)

### 2. Clone the Repository
```bash
git clone https://github.com/your-username/taskflow.git
cd taskflow
```

### 3. Install Dependencies
```bash
flutter pub get
```

### 4. Verify Code Quality
```bash
flutter analyze
```
*(Expected output: `No issues found!`)*

### 5. Run the Application
Ensure an emulator is running or a physical device is connected.
```bash
flutter run
```

---

## 📱 Screenshots

*(Placeholders for future implementation - Add images to `assets/screenshots/`)*

| Splash & Welcome | Authentication | Home (Light) |
|:---:|:---:|:---:|
| <img src="https://via.placeholder.com/250x500.png?text=Splash+Screen" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Login" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Home+Screen" width="250"> |

| Home (Dark Theme) | Filtering & Sorting | Create/Edit Task |
|:---:|:---:|:---:|
| <img src="https://via.placeholder.com/250x500.png?text=Dark+Theme" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Filters" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Add+Task" width="250"> |

---

## 🎯 Assumptions
- Users must be authenticated to use the app; there is no guest mode.
- Tasks are entirely private to the user; there are no shared tasks.
- A single list view is sufficient for the current scale, though pagination may be required as the dataset grows significantly.

---

## 🔮 Future Improvements (Roadmap)
While the application is fully functional for its core requirements, future iterations could include:
- **Dedicated Task Details Screen**: A read-only view for extensive task descriptions and attached media.
- **Hero Animations**: Seamless transitions between the Home list and the Task Details/Edit screens.
- **Offline Support**: Leveraging Firestore's built-in offline persistence for true offline-first capability.
- **Pagination**: Implementing cursor-based pagination if task lists grow into the thousands.
- **Push Notifications**: Reminders for upcoming due dates via Firebase Cloud Messaging.

---
*Built with ❤️ using Flutter and Clean Architecture.*
