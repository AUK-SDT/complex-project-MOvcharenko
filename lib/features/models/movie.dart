import 'package:equatable/equatable.dart';
import '../../../core/constants/app_constants.dart';

class Movie extends Equatable {
  final int id;
  final String title;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String? releaseDate;
  final List<int> genreIds;
  final bool isMovie;

  const Movie({
    required this.id,
    required this.title,
    this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    this.releaseDate,
    this.genreIds = const [],
    this.isMovie = true,
  });

  String? get posterUrl =>
      posterPath != null ? '${AppConstants.posterW342}$posterPath' : null;

  String? get backdropUrl =>
      backdropPath != null ? '${AppConstants.backdropW780}$backdropPath' : null;

  String get year => releaseDate != null && releaseDate!.length >= 4
      ? releaseDate!.substring(0, 4)
      : '';

  String get ratingDisplay => voteAverage.toStringAsFixed(1);

  factory Movie.fromJson(Map<String, dynamic> json, {bool isMovie = true}) {
    final title = isMovie
        ? (json['title'] as String? ?? '')
        : (json['name'] as String? ?? '');
    final releaseDate = isMovie
        ? json['release_date'] as String?
        : json['first_air_date'] as String?;

    return Movie(
      id: json['id'] as int,
      title: title,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: releaseDate,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
      isMovie: isMovie,
    );
  }

  @override
  List<Object?> get props => [id, title, posterPath, voteAverage];
}
