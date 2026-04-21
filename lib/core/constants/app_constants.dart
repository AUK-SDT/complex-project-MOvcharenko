import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConstants {
  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';

  static String get tmdbApiKey => dotenv.env['TMDB_API_KEY'] ?? '';

  static const String posterW342 = '$tmdbImageBaseUrl/w342';
  static const String posterW500 = '$tmdbImageBaseUrl/w500';
  static const String backdropW780 = '$tmdbImageBaseUrl/w780';
  static const String profileW185 = '$tmdbImageBaseUrl/w185';

  static const String watchlistBoxName = 'watchlist';
  static const String settingsBoxName = 'settings';
  static const String themeKey = 'isDarkMode';

  static const int searchDebounceMs = 300;
  static const int paginationLimit = 20;
}
