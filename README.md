# 📱 Visits Tracker – Flutter Mobile Engineer Challenge

**Author:** *Eunice Nzilani*
**Repository:** https://github.com/EuniceNzilani/Visits-Tracker

---

## 🚀 Overview

This Flutter application implements a **Visits Tracker** feature for a Route-to-Market (RTM) Sales Force Automation app. It enables sales reps to manage customer visits through a clean, scalable UI. Users can:

* Add a new customer visit
* View, filter, and search visit history
* Track activities done during each visit
* See basic visit statistics (e.g., how many completed)

The app consumes a RESTful API powered by **Supabase** and is structured to accommodate future feature growth and modular expansion.

---

## 📸 Screenshots

### 🏠 Home Screen<img width="273" alt="visits2" src="https://github.com/user-attachments/assets/5ed68f50-d967-45a8-ae6f-2374e4b2ab12" />

<img width="266" alt="visits4" src="https://github.com/user-attachments/assets/b1d349b1-0be0-40b6-a385-bff901314918" />

<img width="266" alt="visits3" src="https://github.com/user-attachments/assets/a93b3b4e-b206-4494-af16-08b09110cbf1" />






## 🧱 Architectural Overview

The app follows a **clean architecture pattern** with the following layers:

* **Presentation Layer**: Uses `flutter_hooks` and `Riverpod` for clean, reactive state management.
* **Domain Layer**: Defines entities and abstract repositories for flexibility and testability.
* **Data Layer**: Uses `Dio` for HTTP communication and handles mapping between API models and domain models.

### Key Choices

| Feature               | Choice                                                  |
| --------------------- | ------------------------------------------------------- |
| **State Management**  | Riverpod (robust, scalable, test-friendly)              |
| **Navigation**        | `go_router` for declarative and nested navigation       |
| **API Layer**         | REST calls using `Dio`, with centralized error handling |
| **Modular Structure** | Feature-first folder layout for maintainability         |

---

## 🛠️ Setup Instructions

### ✅ Requirements

* Flutter SDK (>=3.10.0)
* Dart (>=3.0.0)
* Android Studio or VS Code
* Emulator or physical device

### 🚨 Steps

1. Clone the repository

   ```bash
   git clone https://github.com/yourusername/flutter-visits-tracker.git
   cd flutter-visits-tracker
   ```

2. Install dependencies

   ```bash
   flutter pub get
   ```

3. Add the API key to your `.env` file

   ```env
   API_URL=https://kqgbftwsodpttpqgqnbh.supabase.co/rest/v1
   API_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```

4. Run the app

   ```bash
   flutter run
   ```

---

## 🔄 Offline Support 

Offline support is not fully implemented but:

* Data layer is designed with `Repository` and caching patterns, so `hive` or `sqflite` can easily be integrated.
* App gracefully handles network failure and retries with fallback UI feedback.

---

## 🧪 Testing 

Basic widget and unit tests included for:

* API service methods
* Visit list filtering
* Visit form validation

To run tests:

```bash
flutter test
```

---

## ⚙️ CI/CD

If time permitted:

* GitHub Actions workflow file prepared for:

  * Static code analysis using `flutter analyze`
  * Test runner with `flutter test`
  * APK build step

---

## 📝 Assumptions & Trade-Offs

* Used basic error UI and no global error handler to save time.
* Did not implement a full authentication flow—assumed static API key usage for demo purposes.
* Basic input validation applied; advanced input sanitization not implemented.
* Used hard-coded activity list fetching, can be cached for offline support later.

---

## ✅ Completed Features

* [x] Add a new visit
* [x] View list of customer visits
* [x] Track visit activities
* [x] Filter/search visits
* [x] View visit statistics
* [x] API integration with Supabase
* [ ] Offline mode (planned)
* [x] Clean modular architecture
* [x] Basic test coverage

---

## 📬 Contact

Feel free to reach out for questions or feedback:
Email: eunicenzilani881@gmail.com


