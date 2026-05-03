import 'package:dio/dio.dart';
import '../../../core/utils/error_mapper.dart';
import '../../../core/utils/failures.dart';
import '../../models/movie.dart';
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
      final results = response.data['results'] as List<dynamic>;
      return results.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<Movie>> fetchPopularTv({int page = 1}) async {
    try {
      final response = await _dio.get(
        '/tv/popular',
        queryParameters: {'page': page},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .map((e) => Movie.fromJson(e as Map<String, dynamic>, isMovie: false))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<Movie>> searchMulti(String query, {int page = 1}) async {
    try {
      final response = await _dio.get(
        '/search/multi',
        queryParameters: {'query': query, 'page': page},
      );
      final results = response.data['results'] as List<dynamic>;
      return results
          .where((e) =>
              e['media_type'] == 'movie' || e['media_type'] == 'tv')
          .map((e) => Movie.fromJson(
                e as Map<String, dynamic>,
                isMovie: e['media_type'] == 'movie',
              ))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<Movie> fetchMovieDetail(int id) async {
    try {
      final response = await _dio.get('/movie/$id');
      return Movie.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<Movie>> fetchSimilar(int id, {bool isMovie = true}) async {
    try {
      final endpoint = isMovie ? '/movie/$id/similar' : '/tv/$id/similar';
      final response = await _dio.get(endpoint);
      final results = response.data['results'] as List<dynamic>;
      return results
          .take(10)
          .map((e) => Movie.fromJson(e as Map<String, dynamic>, isMovie: isMovie))
          .toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }

  Future<List<Genre>> fetchGenres() async {
    try {
      final movieGenres = await _dio.get('/genre/movie/list');
      final tvGenres = await _dio.get('/genre/tv/list');

      final combined = <int, Genre>{};
      for (final g in (movieGenres.data['genres'] as List<dynamic>)) {
        final genre = Genre.fromJson(g as Map<String, dynamic>);
        combined[genre.id] = genre;
      }
      for (final g in (tvGenres.data['genres'] as List<dynamic>)) {
        final genre = Genre.fromJson(g as Map<String, dynamic>);
        combined[genre.id] = genre;
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
      final results = response.data['results'] as List<dynamic>;
      return results.map((e) => Movie.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw mapDioException(e);
    } catch (_) {
      throw const UnknownFailure();
    }
  }
}
