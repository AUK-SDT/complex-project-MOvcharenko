import 'package:dio/dio.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/failures.dart';
import '../../models/media_item.dart';
import '../../models/movie.dart';
import '../../models/tv_show.dart';
import '../../models/genre.dart';

class MovieRepository {
  final Dio _dio;

  const MovieRepository(this._dio);

  Future<List<Movie>> fetchTrending({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/trending/movie/week',
        queryParameters: {'page': page},
      );
      return (response.data['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<TvShow>> fetchPopularTv({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/tv/popular',
        queryParameters: {'page': page},
      );
      return (response.data['results'] as List<dynamic>)
          .map((e) => TvShow.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<MediaItem>> searchMulti(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/multi',
        queryParameters: {'query': query, 'page': page},
      );
      return (response.data['results'] as List<dynamic>)
          .where((e) => e['media_type'] == 'movie' || e['media_type'] == 'tv')
          .map((e) {
            final map = e as Map<String, dynamic>;
            return e['media_type'] == 'movie'
                ? Movie.fromJson(map)
                : TvShow.fromJson(map);
          })
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<MediaItem> fetchDetail(int id, {required bool isMovie}) async {
    try {
      final endpoint = isMovie ? '/movie/$id' : '/tv/$id';
      final response = await _dio.get(endpoint);
      final json = response.data as Map<String, dynamic>;
      return isMovie ? Movie.fromJson(json) : TvShow.fromJson(json);
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<MediaItem>> fetchSimilar(int id, {required bool isMovie}) async {
    try {
      final endpoint = isMovie ? '/movie/$id/similar' : '/tv/$id/similar';
      final response = await _dio.get(endpoint);
      return (response.data['results'] as List<dynamic>)
          .take(10)
          .map((e) {
            final map = e as Map<String, dynamic>;
            return isMovie ? Movie.fromJson(map) : TvShow.fromJson(map);
          })
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<Genre>> fetchGenres() async {
    try {
      final results = await Future.wait([
        _dio.get('/genre/movie/list'),
        _dio.get('/genre/tv/list'),
      ]);

      final combined = <int, Genre>{};
      for (final response in results) {
        for (final g in response.data['genres'] as List<dynamic>) {
          final genre = Genre.fromJson(g as Map<String, dynamic>);
          combined[genre.id] = genre;
        }
      }
      return combined.values.toList()..sort((a, b) => a.name.compareTo(b.name));
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<Movie>> fetchByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/discover/movie',
        queryParameters: {'with_genres': genreId, 'page': page},
      );
      return (response.data['results'] as List<dynamic>)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
