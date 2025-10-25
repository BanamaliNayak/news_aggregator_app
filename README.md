# News Aggregator App 📰

A Flutter-based news aggregator app built for a technical assignment. It fetches live news from the NewsAPI, displays it in categorized tabs, provides offline caching, and allows users to search for articles.

## ✨ Core Features

- **Categorized News:** Fetches and displays news across multiple categories (e.g., business, sports, health).
- **Infinite Scrolling:** Automatically loads more articles as the user scrolls to the bottom of the list (pagination).
- **Pull-to-Refresh:** Allows users to refresh the news feed by pulling down on the list.
- **Offline Mode:** Caches articles locally using **Hive**. If the user is offline, the app seamlessly serves the cached data and displays an "Offline" banner.
- **Search Functionality:** A dedicated search screen allows users to search for articles by keyword, with a 500ms debounce to prevent API spam.
- **In-App WebView:** Opens the full article in an in-app webview (using `webview_flutter`) instead of an external browser, providing a seamless user experience.
- **Theme Management:** Toggle between a light and dark theme, with the preference saved locally to the device.

## 🛠 Tech Stack & Key Packages

- **State Management:** `flutter_bloc`
- **Networking:** `dio`
- **Local Storage (Cache):** `hive`
- **Connectivity:** `connectivity_plus`
- **Service Locator (DI):** `get_it`
- **In-App Browser:** `webview_flutter`
- **Models & Equality:** `equatable`
- **Utilities:** `intl` (date formatting), `logger` (debugging), `rxdart` (search debounce)

## 🚀 Getting Started

### 1. Prerequisites

- Flutter SDK (v3.0.0 or higher)
- An active internet connection
- An Android or iOS device/emulator

### 2. Setup

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/BanamaliNayak/news_aggregator_app.git
    cd news_aggregator
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Set Your API Key:**
    You must get a free API key from [NewsAPI.org](https://newsapi.org).

    - Open the file: `lib/core/config/api_config.dart`
    - Paste your API key into the `apiKey` variable:
      ```dart
      class ApiConfig {
        static const String apiKey = 'YOUR_API_KEY_HERE'; 
        static const String baseUrl = '[https://newsapi.org/v2](https://newsapi.org/v2)';
      }
      ```

4.  **Run Build Runner (for Hive):**
    This generates the necessary adapter files for your local database models.
    ```bash
    flutter pub run build_runner build --delete-conflicting-outputs
    ```

5.  **Configure Android (for WebView):**
    The `webview_flutter` plugin requires a higher minimum SDK version.

    - Open the file: `android/app/build.gradle`
    - In the `defaultConfig` block, change `minSdk` to **20**:
      ```gradle
      defaultConfig {
          ...
          minSdk = 20 // <-- This line
          targetSdk = flutter.targetSdkVersion
          ...
      }
      ```

6.  **Run the app:**
    (You must use `flutter run` after the `minSdk` change, a hot restart is not enough).
    ```bash
    flutter run
    ```