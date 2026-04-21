# CineLog 🎬

A personal movie and TV show tracker built with Flutter, powered by the [TMDB API](https://www.themoviedb.org/).

## Features (Alpha)

| Feature | Status |
|---|---|
| Trending movies & TV shows | ✅ Live |
| Movie / TV switch tab | ✅ Live |
| Search with debounce | ✅ Live |
| Movie detail screen | ✅ Live |
| Add / remove from Watchlist | ✅ Live |
| Mark as watched (CRUD) | ✅ Live |
| Genre browser | 🚧 Placeholder |
| Trailer playback | 🚧 Coming soon |
| Cast detail screen | 🚧 Coming soon |

## Architecture

```
lib/
├── core/
│   ├── constants/     # AppConstants, AppRoutes
│   ├── network/       # Dio ApiClient
│   ├── theme/         # AppTheme (dark + light)
│   └── utils/         # Failures, ErrorMapper, ServiceLocator
├── features/
│   ├── home/          # HomeCubit, HomeState, MovieRepository, widgets
│   ├── search/        # SearchCubit, SearchState
│   ├── detail/        # DetailCubit, DetailState
│   ├── watchlist/     # WatchlistCubit, WatchlistRepository (Hive)
│   └── genre/         # GenreScreen (placeholder)
└── shared/
    └── widgets/       # MovieCard, ErrorView, SectionHeader
```

**State management:** BLoC / Cubit  
**Networking:** Dio + dio_cache_interceptor  
**Local storage:** Hive  
**Navigation:** go_router  
**DI:** get_it

## Setup

### 1. Get a free TMDB API key

1. Create a free account at [themoviedb.org](https://www.themoviedb.org/)
2. Go to **Settings → API** and request a key (takes ~1 minute)

### 2. Add your key

Open `lib/core/constants/app_constants.dart` and replace the placeholder:

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

> **Note:** The `watchlist_item.g.dart` file is already included. If you modify `WatchlistItem`, regenerate it with:
> ```bash
> flutter pub run build_runner build --delete-conflicting-outputs
> ```
