# TaskFlow - To-Do & Task Management Application

**TaskFlow** is a production-grade Flutter application for task and to-do management built with **Clean Architecture**, **BLoC State Management**, **Firebase Authentication**, and **Cloud Firestore** user-isolated real-time synchronization.

---

## Features

- 🔑 **Firebase Authentication**: Email and password login, user registration with validation, and password reset email flow.
- 🔒 **User Data Isolation**: Tasks are stored securely in Firestore under `users/{uid}/tasks/{taskId}`, protected by production-level Firestore Security Rules.
- 📋 **Task CRUD Operations**:
  - **Create Task**: Add new tasks with title, description, priority (`Low`, `Medium`, `High`), status (`To Do`, `In Progress`, `Completed`), and due date picker.
  - **Read / Realtime Sync**: Live streaming list updates automatically as tasks are created, updated, or deleted.
  - **Edit Task**: Reusable form pre-filled with existing task data. Preserves creation timestamp and updates modification timestamp.
  - **Delete Task**: Safe task deletion with Material 3 modal confirmation dialog.
- 🎨 **Material 3 Design**: Vibrant color system, custom typography, responsive feedback, and consistent design language.

---

## Clean Architecture Overview

The project is structured following strict **Clean Architecture** principles into three primary layers:

```text
lib/
├── config/                  # App constants & routing
├── core/                    # Utilities, validation, theme, global widgets
├── di.dart                  # Service locator configuration (GetIt)
└── features/
    ├── authentication/      # Auth Feature (Data, Domain, Presentation)
    └── tasks/               # Tasks Feature
        ├── data/
        │   ├── datasources/ # TaskRemoteDataSource & Firestore integration
        │   ├── models/      # TaskModel & Firestore serialization
        │   └── repositories/# TaskRepositoryImpl implementation
        ├── domain/
        │   ├── entities/    # Pure TaskEntity & priority/status enums
        │   ├── repositories/# Abstract TaskRepository contract
        │   └── usecases/    # GetTasks, AddTask, UpdateTask, DeleteTask Use Cases
        └── presentation/
            ├── bloc/        # TaskBloc, TaskEvent, TaskState
            ├── pages/       # HomePage, AddTaskPage, EditTaskPage
            └── widgets/     # Modular form, list, card, & dialog widgets
```

### Data Flow
```text
UI (Pages & Widgets)
       ↓
   TaskBloc
       ↓
   Use Cases (GetTasks, AddTask, UpdateTask, DeleteTask)
       ↓
  TaskRepository (Domain Contract)
       ↓
TaskRepositoryImpl (Data Implementation)
       ↓
TaskRemoteDataSource (Firestore Data Source)
       ↓
 Cloud Firestore / Firebase Auth
```

---

## Tech Stack & Dependencies

- **Framework**: Flutter (Dart)
- **Design System**: Material 3
- **State Management**: `flutter_bloc: ^8.1.3`
- **Dependency Injection**: `get_it: ^8.0.3`
- **Backend & Auth**: `firebase_core`, `firebase_auth`, `cloud_firestore`
- **Utility**: `intl`, `equatable`

---

## Firestore Data Structure & Security Rules

### Data Structure
```text
users
 └── {uid}
      └── tasks
           └── {taskId}
                ├── id: String
                ├── title: String
                ├── description: String
                ├── priority: String ("low" | "medium" | "high")
                ├── status: String ("todo" | "inProgress" | "completed")
                ├── dueDate: Timestamp?
                ├── createdAt: Timestamp
                └── updatedAt: Timestamp
```

### Security Rules (`firestore.rules`)
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if false;
    }

    match /users/{userId}/tasks/{taskId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

---

## Getting Started

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Firebase Project configured for Android (`google-services.json`) & iOS (`GoogleService-Info.plist`)

### Local Setup & Execution
1. Clone the repository and navigate to the project directory:
   ```bash
   cd "To-Do Management Application"
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Verify static analysis:
   ```bash
   flutter analyze
   ```
4. Run the application:
   ```bash
   flutter run
   ```
