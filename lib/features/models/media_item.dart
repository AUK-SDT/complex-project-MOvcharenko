import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';

// Common interface for both Movie and TvShow.
// Using an abstract class (not a sealed class) keeps it compatible with
// Dart <3.0 and avoids exhaustive-switch requirements at every call site.
abstract class MediaItem extends Equatable {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final List<int> genreIds;

  const MediaItem({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    this.releaseDate,
    this.genreIds = const [],
  });

  bool get isMovie;

  String? get posterUrl =>
      posterPath != null ? '${AppConstants.posterW342}$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null ? '${AppConstants.backdropW780}$backdropPath' : null;

  String get year => releaseDate != null && releaseDate!.length >= 4
      ? releaseDate!.substring(0, 4)
      : '';

  String get ratingDisplay => voteAverage.toStringAsFixed(1);

  @override
  List<Object?> get props => [id, title, posterPath, voteAverage];
}
