import 'package:hive_flutter/hive_flutter.dart';
import '../models/watchlist_item.dart';
import '../../home/models/movie.dart';
import '../../../core/constants/app_constants.dart';

class WatchlistRepository {
  Box<WatchlistItem> get _box => Hive.box<WatchlistItem>(AppConstants.watchlistBoxName);

  List<WatchlistItem> getAll() => _box.values.toList()
    ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

  bool isInWatchlist(int id) => _box.containsKey(id);

  Future<void> add(Movie movie) async {
    final item = WatchlistItem(
      id: movie.id,
      title: movie.title,
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
      releaseDate: movie.releaseDate,
      isMovie: movie.isMovie,
      addedAt: DateTime.now(),
    );
    await _box.put(movie.id, item);
  }

  Future<void> remove(int id) async {
    await _box.delete(id);
  }

  Future<void> toggleWatched(int id) async {
    final item = _box.get(id);
    if (item != null) {
      item.isWatched = !item.isWatched;
      await item.save();
    }
  }
}
