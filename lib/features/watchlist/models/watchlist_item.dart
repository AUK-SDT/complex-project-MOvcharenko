import 'package:hive_flutter/hive_flutter.dart';

part 'watchlist_item.g.dart';

@HiveType(typeId: 0)
class WatchlistItem extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? posterPath;

  @HiveField(3)
  final double voteAverage;

  @HiveField(4)
  final String? releaseDate;

  @HiveField(5)
  final bool isMovie;

  @HiveField(6)
  bool isWatched;

  @HiveField(7)
  final DateTime addedAt;

  WatchlistItem({
    required this.id,
    required this.title,
    this.posterPath,
    required this.voteAverage,
    this.releaseDate,
    required this.isMovie,
    this.isWatched = false,
    required this.addedAt,
  });

  String? get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w342$posterPath' : null;

  String get year => releaseDate != null && releaseDate!.length >= 4
      ? releaseDate!.substring(0, 4)
      : '';
}
