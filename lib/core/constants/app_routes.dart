abstract class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String detail = '/detail/:id';
  static const String watchlist = '/watchlist';
  static const String genre = '/genre/:id';

  static String detailPath(int id, {required bool isMovie}) =>
      '/detail/$id?type=${isMovie ? 'movie' : 'tv'}';

  static String genrePath(int genreId, String genreName) =>
      '/genre/$genreId?name=${Uri.encodeComponent(genreName)}';
}
