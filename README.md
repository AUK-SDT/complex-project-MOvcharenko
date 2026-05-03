# CineLog 🎬

A personal movie and TV show tracker built with Flutter, powered by the [TMDB API](https://www.themoviedb.org/). Browse trending content, search millions of titles, and manage your own watchlist — all with a clean, responsive UI and full offline support for saved items.

---

## Screenshots

> Run the app and take screenshots to place here.

---

## Features

| Feature | Status |
|---|---|
| Trending movies feed | ✅ Live |
| Popular TV shows feed | ✅ Live |
| Movies / TV tab toggle | ✅ Live |
| Hero banner for featured title | ✅ Live |
| Browse genres via chip row | ✅ Live |
| Genre detail screen with pagination | ✅ Live |
| Full-text search with debounce | ✅ Live |
| Movie / show detail screen | ✅ Live |
| Similar titles on detail screen | ✅ Live |
| Add / remove from Watchlist | ✅ Live |
| Mark titles as watched | ✅ Live |
| Swipe-to-delete on Watchlist | ✅ Live |
| Shimmer loading skeletons | ✅ Live |
| Error states with retry | ✅ Live |
| Pull-to-refresh | ✅ Live |
| Dark / light theme | ✅ Live |
| Trailer playback | 🚧 Coming soon |
| Cast detail screen | 🚧 Coming soon |
| User ratings & reviews | 🚧 Coming soon |

---

## Tech Stack

| Layer | Package | Version |
|---|---|---|
| State management | `flutter_bloc` / Cubit | ^8.1.5 |
| Networking | `dio` | ^5.4.3 |
| Network caching | `dio_cache_interceptor` | ^3.5.0 |
| Local storage | `hive_flutter` | ^1.1.0 |
| Navigation | `go_router` | ^13.2.4 |
| Dependency injection | `get_it` | ^7.7.0 |
| Image loading & caching | `cached_network_image` | ^3.3.1 |
| Loading skeletons | `shimmer` | ^3.0.0 |
| Typography | `google_fonts` | ^6.2.1 |
| Value equality | `equatable` | ^2.0.5 |

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- A free [TMDB API key](https://www.themoviedb.org/settings/api) (takes about one minute to obtain — no credit card required)

### 1. Clone the repository

```bash
git clone https://github.com/your-username/cinelog.git
cd cinelog
```

### 2. Add your TMDB API key

Open `lib/core/constants/app_constants.dart` and replace the placeholder value:

```dart
static const String tmdbApiKey = 'YOUR_TMDB_API_KEY_HERE';
```

### 3. Install dependencies

```bash
flutter pub get
```

### 4. Run the app

```bash
flutter run
```

The app runs on Android, iOS, and Web with no additional configuration.

### Re-generating Hive adapters

The generated file `watchlist_item.g.dart` is already included in the repository. If you modify `WatchlistItem`, re-run the code generator:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Architecture

CineLog follows a **feature-first folder structure** with a strict separation of concerns. Each feature is self-contained and holds its own state logic, repository, and UI. Shared code lives in `core/` and `shared/`.

### Folder structure

```
lib/
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart     # API base URLs, image sizes, box names, key strings
│   │   └── app_routes.dart        # Named route paths and path-builder helpers
│   ├── network/
│   │   └── api_client.dart        # Dio singleton with cache interceptor and logging
│   ├── theme/
│   │   └── app_theme.dart         # Dark and light ThemeData, typography, colour scheme
│   └── utils/
│       ├── failures.dart          # Typed failure hierarchy (Network, Server, NotFound, Unknown)
│       ├── error_mapper.dart      # Maps DioException → Failure
│       └── service_locator.dart   # get_it registrations for all cubits and repositories
│
├── features/
│   │
│   ├── models/                    # Shared domain models used across multiple features
│   │   ├── movie.dart             # Movie / TV show entity + fromJson factory
│   │   └── genre.dart             # Genre entity + fromJson factory
│   │
│   ├── home/
│   │   ├── cubit/
│   │   │   ├── home_cubit.dart    # Loads trending + TV + genres in parallel; tab switching
│   │   │   └── home_state.dart    # HomeInitial | HomeLoading | HomeLoaded | HomeError
│   │   ├── repository/
│   │   │   └── movie_repository.dart  # All TMDB API calls (7 methods, all async/await)
│   │   ├── widgets/
│   │   │   ├── hero_banner.dart        # Full-width featured title banner with gradient overlay
│   │   │   ├── horizontal_movie_list.dart  # Horizontal scrolling card list with shimmer fallback
│   │   │   ├── content_tab_selector.dart   # Animated Movies / TV Shows toggle
│   │   │   └── genre_chip_row.dart         # Horizontally scrollable genre chip strip
│   │   └── home_screen.dart
│   │
│   ├── search/
│   │   ├── cubit/
│   │   │   ├── search_cubit.dart  # Debounced query handling (300 ms); delegates to MovieRepository
│   │   │   └── search_state.dart  # SearchInitial | SearchLoading | SearchLoaded | SearchEmpty | SearchError
│   │   └── search_screen.dart     # Inline AppBar search field; 3-column results grid
│   │
│   ├── detail/
│   │   ├── cubit/
│   │   │   ├── detail_cubit.dart  # Loads movie detail + similar titles + watchlist status in parallel
│   │   │   └── detail_state.dart  # DetailInitial | DetailLoading | DetailLoaded | DetailError
│   │   └── detail_screen.dart     # SliverAppBar backdrop, meta row, overview, similar titles, watchlist toggle
│   │
│   ├── watchlist/
│   │   ├── cubit/
│   │   │   ├── watchlist_cubit.dart   # load(), toggleWatched(), remove()
│   │   │   └── watchlist_state.dart   # WatchlistInitial | WatchlistLoaded (split into watched / unwatched)
│   │   ├── models/
│   │   │   ├── watchlist_item.dart    # Hive entity (@HiveType typeId: 0)
│   │   │   └── watchlist_item.g.dart  # Generated TypeAdapter (do not edit by hand)
│   │   ├── repository/
│   │   │   └── watchlist_repository.dart  # Hive box CRUD: getAll, isInWatchlist, add, remove, toggleWatched
│   │   └── watchlist_screen.dart      # Two sections (To Watch / Watched), swipe-to-delete
│   │
│   └── genre/
│       ├── cubit/
│       │   ├── genre_cubit.dart   # loadGenre(), loadMore() with pagination guard, retry()
│       │   └── genre_state.dart   # GenreInitial | GenreLoading | GenreLoaded | GenreError
│       └── genre_screen.dart      # Pinned SliverAppBar, 3-column SliverGrid, scroll-triggered pagination
│
├── shared/
│   └── widgets/
│       ├── movie_card.dart     # Layout-agnostic poster card (works in lists and grids via Expanded)
│       ├── error_view.dart     # Centred icon + message + retry button
│       └── section_header.dart # Row with title and optional "See all" action
│
├── app.dart         # MaterialApp.router with dark/light ThemeData
├── app_router.dart  # GoRouter config: ShellRoute (home + watchlist) + push routes
├── shell_screen.dart # Persistent BottomNavigationBar shell
└── main.dart        # Hive init, adapter registration, box opening, service locator setup, runApp
```

### Data flow

```
UI (Screen)
  └─► Cubit.method()
        └─► Repository.fetch()         # MovieRepository (network) or WatchlistRepository (Hive)
              └─► ApiClient.dio.get()  # Dio + cache interceptor
              └─► mapDioException()    # DioException → typed Failure on error
        └─► emit(NewState)
  └─► BlocBuilder rebuilds only affected widgets
```

### State management

Each feature has its own **Cubit** — a lightweight BLoC variant that exposes imperative methods rather than event classes. All states extend `Equatable` so `BlocBuilder` skips rebuilds when the emitted state is value-equal to the previous one.

Cubits are instantiated per-route via `BlocProvider` inside the router, so they are automatically disposed when the user navigates away. The one exception is `WatchlistCubit`, which is re-loaded via `load()` on `initState` each time the screen is visited, keeping the list fresh after changes made on the detail screen.

### Error handling

`MovieRepository` catches `DioException` and maps it to a typed `Failure` subclass (`NetworkFailure`, `ServerFailure`, `NotFoundFailure`, `UnknownFailure`) via `error_mapper.dart`. Cubits catch `Failure` specifically and emit an error state containing it. The `ErrorView` widget inspects the failure type to show a contextual icon and message, always alongside a retry callback.

### Local persistence

`WatchlistRepository` wraps a **Hive** box keyed by movie ID. Because Hive stores values in a `Map<dynamic, WatchlistItem>`, lookups (`isInWatchlist`) and deletes (`remove`) are O(1). The `WatchlistItem` model holds a snapshot of the data available at the time of saving so the Watchlist screen works entirely offline.

### Navigation

`go_router` is configured with a `ShellRoute` that renders the persistent `BottomNavigationBar` around the Home and Watchlist destinations. The Search, Detail, and Genre screens are push routes layered on top. Genre names are passed as URI-encoded query parameters (`/genre/28?name=Action`) so the screen can show its title during the initial loading state before the Cubit emits.

---

## API Reference

All data comes from the [TMDB API v3](https://developer.themoviedb.org/docs). The endpoints used are:

| Endpoint | Used for |
|---|---|
| `GET /trending/movie/week` | Home screen trending movies |
| `GET /tv/popular` | Home screen popular TV shows |
| `GET /search/multi` | Search screen (movies + TV in one call) |
| `GET /movie/{id}` | Movie detail screen |
| `GET /movie/{id}/similar` | Similar titles on detail screen |
| `GET /tv/{id}/similar` | Similar titles for TV shows |
| `GET /genre/movie/list` | Genre chip row (merged with TV genres) |
| `GET /genre/tv/list` | Genre chip row (merged with movie genres) |
| `GET /discover/movie` | Genre detail screen with `with_genres` filter |

Responses are cached in memory for 30 minutes via `dio_cache_interceptor` to reduce redundant network calls when navigating back to previously visited screens.

---

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

> This app uses the TMDB API but is not endorsed or certified by TMDB.
