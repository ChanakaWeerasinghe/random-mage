# 🎨 Random Image Viewer (Flutter)

A minimal, elegant **Flutter mobile app** that fetches random images from an API and adapts the background color dynamically based on the image’s dominant color.

This project demonstrates clean Flutter architecture, reactive UI, state management, and smooth transitions while following best practices for code structure and error handling.

---

## 📱 Overview

**Objective:**  
Create a single-screen Flutter app that:
- Fetches a random image via a GET API.
- Displays it **centered as a square**.
- Adapts the **background color** to match the image’s dominant color.
- Provides a button labeled **“Another”** to fetch a new image.
- Shows a **loading indicator** while fetching.
- Handles **errors gracefully** with retry options.
- Supports **light/dark mode** and **accessibility**.

---

## 🌐 API Endpoint

**Endpoint:**
```
GET https://november7-730026606190.europe-west1.run.app/image
```

**Example Response:**
```json
{
  "url": "https://images.unsplash.com/photo-1506744038136-46273834b3fb"
}
```

All images are served from **Unsplash** and can be treated as large remote images.  
CORS is already enabled on the backend.

---

## 🧱 Architecture

The app uses a clean, layered architecture for scalability and maintainability:

```
lib/
├─ core/
│  ├─ failure.dart          # Error model (Failure)
│  └─ result.dart           # Functional Result<T> type
├─ data/
│  ├─ image_api.dart        # Network layer (HTTP GET)
│  ├─ image_repository.dart # Repository logic
│  └─ models/
│     └─ remote_image_dto.dart
├─ domain/
│  └─ entities/
│     └─ remote_image.dart  # Entity representation
├─ services/
│  └─ palette_service.dart  # Extracts dominant color from image
├─ presentation/
│  ├─ pages/
│  │  └─ random_image_page.dart
│  ├─ state/
│  │  └─ random_image_state.dart
│  └─ viewmodels/
│     └─ random_image_viewmodel.dart
└─ main.dart                # Entry point & dependency injection
```

### ✳️ Key Architectural Principles

| Principle | Description |
|------------|-------------|
| **Separation of Concerns** | API, Repository, ViewModel, and UI layers are isolated for testability. |
| **Result-based Error Handling** | Uses a `Result<T>` type to separate success/failure logic cleanly. |
| **Reactive State Management** | `ChangeNotifier` powers real-time UI updates. |
| **Palette Service** | Extracts image colors efficiently using `palette_generator`. |
| **Resilience** | Network failures, timeouts, and invalid responses are handled gracefully. |

---

## ⚙️ Features

| Feature | Description |
|----------|--------------|
| 🖼️ **Dynamic Image Fetch** | Loads random image from the API endpoint. |
| 🟩 **Adaptive Background** | Changes background color using the image’s dominant color. |
| 🔁 **Fetch Another** | “Another” button requests a new random image. |
| ⏳ **Loading Indicator** | Shimmer placeholder during image load. |
| ⚠️ **Error Handling** | User-friendly error messages and retry button. |
| 🌗 **Light/Dark Mode** | Adapts seamlessly to system theme. |
| ♿ **Accessibility** | Semantic labels for screen readers. |
| 🎞️ **Smooth Transitions** | Fade-in image and animated background color. |

---

## 🧠 Tech Stack

- **Flutter 3.24+**
- **Dart 3.4+**
- **HTTP** – for REST API requests
- **cached_network_image** – for caching and image fade-ins
- **palette_generator** – for extracting dominant colors
- **Material 3** – for UI design and theming

---

## 🚀 Getting Started

### 1️⃣ Clone the Repository
```bash
git clone https://github.com/<your-username>/random-image-viewer-flutter.git
cd random-image-viewer-flutter
```

### 2️⃣ Install Dependencies
```bash
flutter pub get
```

### 3️⃣ Run the App
```bash
flutter run
```

The app runs on:
- ✅ Android
- ✅ iOS
- ✅ Web (CORS supported)

---

## 🧩 Design Decisions

| Aspect | Choice | Reason |
|--------|--------|--------|
| **Architecture** | MVVM + Repository | Separation of data, logic, and UI |
| **Error Model** | Custom `Failure` & `Result<T>` | Simplifies async error flow |
| **Background Adaptation** | PaletteGenerator | Reliable dominant color extraction |
| **Animations** | `AnimatedContainer` + `AnimatedSwitcher` | Smooth transitions |
| **Accessibility** | Flutter Semantics API | Screen reader compatibility |
| **Fallback Colors** | Theme-aware gray tones | Works in both light/dark mode |

---

## 🧪 Error Scenarios Handled

| Scenario | Behavior |
|-----------|-----------|
| **No Internet** | Displays “Network error — check your connection.” |
| **Timeout** | Shows “Request timed out.” |
| **Server Error** | Displays response code and retry option. |
| **Bad JSON** | Shows “Unexpected response from the server.” |
| **Other Exceptions** | Shows generic fallback message. |

---

## 🧭 Future Enhancements

- 🔁 Pull-to-refresh gesture
- 💾 Offline image caching (Hive)
- 🧠 Smart color prediction for palettes
- 🪄 Haptics for button interactions
- 🧪 Unit & widget testing

---

## 🎥 Demo

A short screen recording is included to show:
1. App launch
2. Image loading
3. Background color transition
4. Tapping “Another” multiple times
5. Error message and retry button

Add your demo here:
```
https://drive.google.com/file/d/1K_ohNNYy9pil9L211dlA7fUFjbvclXB1/view?usp=drive_link
```

---

## 👨‍💻 Author

**Chanaka Weerasinghe**  
Senior Mobile Engineer — Flutter • iOS • Android • Web  
📧 [chanakaweerasinghe92@gmail.com](mailto:chanakaweerasinghe92@gmail.com)  
📍 Scarborough, Ontario, Canada
+14377667149

---

## 🪪 License

This project is for educational and technical demonstration purposes only.  
© 2025 Chanaka Weerasinghe. All rights reserved.

---
