# 🏛️ Application Architecture

This project follows the principles of **Clean Architecture** adapted for a Flutter application. The primary goal is to create a clear separation of concerns, making the app scalable, testable, and maintainable.

The project is split into three main layers: **Features (Presentation)**, **Domain**, and **Data**.

---

## 📁 Directory Structure

The `lib` folder is organized as follows:

```
lib/
├── app/                       # Root MaterialApp, theme, etc.
├── core/                      # Shared services (network, DB, config, DI)
├── data/                      # Data Layer (Repositories, DataSources, Models)
├── domain/                    # Domain Layer (Abstract Repositories / Contracts)
├── features/                  # Presentation Layer (Screens, Widgets, BLoCs)
└── injection_container.dart   # Service locator setup using get_it
```

---

## 1. Layers Explained

### `features` (Presentation Layer)

- **What it does:** This layer is responsible for everything the user sees. It contains all UI (Screens, Widgets) and the BLoCs that manage the UI's state.
- **Key Rules:**
    - A `features` widget (e.g., `NewsCategoryTab`) **sends events** to its BLoC (e.g., `FetchNews`).
    - A `features` widget **listens to states** from its BLoC (e.g., `NewsLoading`, `NewsSuccess`) and rebuilds the UI accordingly.
    - This layer **does not** know anything about `Dio` or `Hive`. It only talks to the BLoC.

---

### `domain` (Domain Layer)

- **What it does:** This is the core of the application. It defines the "contract" for what the app *can do*, but not *how* it does it.
- **Key Components:**
    - **Abstract Repositories** (e.g., `NewsRepository`): An interface that defines methods like `Future<Either<Failure, FetchResult>> getTopHeadlines(...)`.
- **Key Rules:**
    - This layer is **pure Dart** and has **zero dependencies** on Flutter, `Dio`, `Hive`, or any other layer.
    - It is highly reusable and testable.

---

### `data` (Data Layer)

- **What it does:** This layer *implements* the contract from the `domain` layer. It is responsible for fetching and caching the actual data.
- **Key Components:**
    - **Repository Implementations** (e.g., `NewsRepositoryImpl`): Implements the `NewsRepository` interface and contains core logic.
    - **Data Sources:**
        - `NewsRemoteDataSource`: Uses **Dio** to make API calls to NewsAPI.
        - `NewsLocalDataSource`: Uses **Hive** to save and retrieve articles from the local cache.
    - **Models** (e.g., `ArticleModel`): Data structures that include `fromJson` methods to parse API responses and `@HiveField` annotations for local storage.

---

## 2. State Management (BLoC)

- **Library:** `flutter_bloc`
- **Role:** BLoCs (e.g., `NewsBloc`, `SearchBloc`, `ThemeBloc`) act as the bridge between the `features` and `domain` layers.

### Data Flow

1. **UI** sends an **Event** (e.g., `RefreshNews`).
2. **BLoC** receives the Event and calls the appropriate method on the `NewsRepository` (from the `domain` layer).
3. **BLoC** emits a **State** (e.g., `NewsState(status: NewsStatus.loading)`).
4. The `Repository` (in the `data` layer) fetches the data.
5. The `Repository` returns the data (or a failure) to the BLoC.
6. **BLoC** emits a new **State** (e.g., `NewsState(status: NewsStatus.success, articles: ...)`).
7. **UI** (via `BlocBuilder`) rebuilds itself based on the new state.

---

## 3. Data Flow: “Fetch News” Example

Here’s what happens when a user opens a category tab:

1. **UI (`NewsCategoryTab`)**
    - `initState` is called, which dispatches `_newsBloc.add(FetchNews(category: "sports"))`.

2. **BLoC (`NewsBloc`)**
    - Receives the event.
    - Emits `NewsState(status: loadingMore)`.
    - Calls `repository.getTopHeadlines(category: "sports", page: 1)`.

3. **Repository (`NewsRepositoryImpl`)**  
   a. Checks `ConnectivityService.isConnected`.  
   b. **If Online:**
    - Calls `remoteDataSource.getTopHeadlines(...)`.
    - The remote data source uses **Dio** to call the NewsAPI.
    - Parses the returned JSON into `List<ArticleModel>`.
    - Calls `localDataSource.clearCache("sports")` (for page 1 refresh).
    - Calls `localDataSource.cacheTopHeadlines(...)` to store the fetched articles in Hive.
    - Returns `Right(FetchResult(articles: ...))` to the BLoC.
      c. **If Offline:**
    - Calls `localDataSource.getTopHeadlines("sports")`.
    - Retrieves cached articles from Hive.
    - Returns `Right(FetchResult(articles: ..., isFromCache: true))` to the BLoC.

4. **BLoC (`NewsBloc`)**
    - Receives the `FetchResult` from the repository.
    - **If Online:** Emits `NewsState(status: success, articles: ..., page: 2)`.
    - **If Offline:** Emits `NewsState(status: cached, articles: ...)`.

5. **UI (`NewsCategoryTab`)**
    - `BlocBuilder` rebuilds based on the new state.
    - If status is `cached`, displays “Offline. Showing cached data.” banner.
    - Displays articles in a `ListView.builder`.

---

## 4. Code Style Guidelines

- Organize code using **regions**:  
  Use `// region` and `// endregion` comments for classes, functions, and helpers.  
  This improves readability in IDEs and helps manage large files efficiently.
- Follow common clean code practices:
    - Keep methods small and focused.
    - Use meaningful naming conventions.
    - Prefer immutability and pure functions in the `domain` layer.
    - Avoid direct dependencies between non-adjacent layers.

---
```
