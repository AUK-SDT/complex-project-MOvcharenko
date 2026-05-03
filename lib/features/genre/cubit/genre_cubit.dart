import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/repository/movie_repository.dart';
import '../../models/genre.dart';
import '../../../core/utils/failures.dart';
import 'genre_state.dart';

class GenreCubit extends Cubit<GenreState> {
  final MovieRepository _repository;

  GenreCubit(this._repository) : super(const GenreInitial());

  Future<void> loadGenre(Genre genre) async {
    emit(const GenreLoading());
    try {
      final movies = await _repository.fetchByGenre(genre.id);
      emit(GenreLoaded(genre: genre, movies: movies));
    } on Failure catch (f) {
      emit(GenreError(f));
    } catch (_) {
      emit(GenreError(const UnknownFailure()));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! GenreLoaded) return;
    if (current.isLoadingMore || current.hasReachedEnd) return;

    emit(current.copyWith(isLoadingMore: true));
    try {
      final nextPage = current.currentPage + 1;
      final newMovies = await _repository.fetchByGenre(
        current.genre.id,
        page: nextPage,
      );

      emit(current.copyWith(
        movies: [...current.movies, ...newMovies],
        isLoadingMore: false,
        hasReachedEnd: newMovies.isEmpty,
        currentPage: nextPage,
      ));
    } on Failure catch (f) {
      // Revert to previous loaded state but surface the error via flag
      emit(current.copyWith(isLoadingMore: false));
      addError(f);
    } catch (_) {
      emit(current.copyWith(isLoadingMore: false));
    }
  }

  Future<void> retry(Genre genre) => loadGenre(genre);
}
