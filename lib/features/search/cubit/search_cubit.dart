import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../home/repository/movie_repository.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/failures.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository _repository;
  Timer? _debounce;

  SearchCubit(this._repository) : super(const SearchInitial());

  void onQueryChanged(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      emit(const SearchInitial());
      return;
    }

    emit(const SearchLoading());

    _debounce = Timer(
      const Duration(milliseconds: AppConstants.searchDebounceMs),
      () => _search(query.trim()),
    );
  }

  Future<void> _search(String query) async {
    try {
      final results = await _repository.searchMulti(query);
      if (results.isEmpty) {
        emit(SearchEmpty(query));
      } else {
        emit(SearchLoaded(results: results, query: query));
      }
    } on Failure catch (f) {
      emit(SearchError(f));
    } catch (_) {
      emit(SearchError(const UnknownFailure()));
    }
  }

  void clear() {
    _debounce?.cancel();
    emit(const SearchInitial());
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
