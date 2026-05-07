import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/repository/movie_repository.dart';
import '../../watchlist/repository/watchlist_repository.dart';
import '../../../core/utils/failures.dart';
import 'detail_state.dart';

class DetailCubit extends Cubit<DetailState> {
  final MovieRepository _movieRepository;
  final WatchlistRepository _watchlistRepository;

  DetailCubit(this._movieRepository, this._watchlistRepository)
      : super(const DetailInitial());

  Future<void> loadDetail(int id, {required bool isMovie}) async {
    emit(const DetailLoading());
    try {
      final results = await Future.wait([
        _movieRepository.fetchDetail(id, isMovie: isMovie),
        _movieRepository.fetchSimilar(id, isMovie: isMovie),
      ]);

      emit(DetailLoaded(
        item: results[0] as dynamic,
        similar: results[1] as dynamic,
        isInWatchlist: _watchlistRepository.isInWatchlist(id),
      ));
    } on Failure catch (f) {
      emit(DetailError(f));
    } catch (_) {
      emit(DetailError(const UnknownFailure()));
    }
  }

  Future<void> toggleWatchlist() async {
    final current = state;
    if (current is! DetailLoaded) return;

    if (current.isInWatchlist) {
      await _watchlistRepository.remove(current.item.id);
    } else {
      await _watchlistRepository.add(current.item);
    }

    emit(current.copyWith(isInWatchlist: !current.isInWatchlist));
  }
}
