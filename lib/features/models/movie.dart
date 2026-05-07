import 'media_item.dart';

class Movie extends MediaItem {
  const Movie({
    required super.id,
    required super.title,
    super.overview,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    super.releaseDate,
    super.genreIds,
  });

  @override
  bool get isMovie => true;

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['release_date'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }
}
