import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/watchlist_repository.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final WatchlistRepository _repository;

  WatchlistCubit(this._repository) : super(const WatchlistInitial());

  void load() => emit(WatchlistLoaded(_repository.getAll()));

  Future<void> toggleWatched(int id) async {
    await _repository.toggleWatched(id);
    load();
  }

  Future<void> remove(int id) async {
    await _repository.remove(id);
    load();
  }
}
