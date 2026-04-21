abstract class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String detail = '/detail/:id';
  static const String watchlist = '/watchlist';
  static const String genre = '/genre/:id';

  static String detailPath(int movieId) => '/detail/$movieId';
  static String genrePath(int genreId) => '/genre/$genreId';
}
