import 'media_item.dart';

class TvShow extends MediaItem {
  const TvShow({
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
  bool get isMovie => false;

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      id: json['id'] as int,
      title: json['name'] as String? ?? '',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      releaseDate: json['first_air_date'] as String?,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }
}
