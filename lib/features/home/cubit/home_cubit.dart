import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/movie_repository.dart';
import '../../models/movie.dart';
import '../../models/tv_show.dart';
import '../../models/genre.dart';
import '../../../core/utils/failures.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MovieRepository _repository;

  HomeCubit(this._repository) : super(const HomeInitial());

  Future<void> loadHome() async {
    emit(const HomeLoading());
    try {
      final results = await Future.wait([
        _repository.fetchTrending(),
        _repository.fetchPopularTv(),
        _repository.fetchGenres(),
      ]);

      emit(HomeLoaded(
        trending: results[0] as List<Movie>,
        tvShows: results[1] as List<TvShow>,
        genres: results[2] as List<Genre>,
      ));
    } on Failure catch (f) {
      emit(HomeError(f));
    } catch (_) {
      emit(HomeError(const UnknownFailure()));
    }
  }

  void switchTab(HomeTab tab) {
    final current = state;
    if (current is HomeLoaded) {
      emit(current.copyWith(activeTab: tab));
    }
  }

  Future<void> retry() => loadHome();
}
