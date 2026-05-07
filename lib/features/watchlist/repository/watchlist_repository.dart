import 'package:hive_flutter/hive_flutter.dart';
import '../models/watchlist_item.dart';
import '../../models/media_item.dart';
import '../../../core/constants/app_constants.dart';

class WatchlistRepository {
  Box<WatchlistItem> get _box =>
      Hive.box<WatchlistItem>(AppConstants.watchlistBoxName);

  List<WatchlistItem> getAll() => _box.values.toList()
    ..sort((a, b) => b.addedAt.compareTo(a.addedAt));

  bool isInWatchlist(int id) => _box.containsKey(id);

  Future<void> add(MediaItem item) async {
    final entry = WatchlistItem(
      id: item.id,
      title: item.title,
      posterPath: item.posterPath,
      voteAverage: item.voteAverage,
      releaseDate: item.releaseDate,
      isMovie: item.isMovie,
      addedAt: DateTime.now(),
    );
    await _box.put(item.id, entry);
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
