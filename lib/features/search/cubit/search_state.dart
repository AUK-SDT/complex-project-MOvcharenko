import 'package:equatable/equatable.dart';
import '../../models/media_item.dart';
import '../../../core/utils/failures.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<MediaItem> results;
  final String query;

  const SearchLoaded({required this.results, required this.query});

  @override
  List<Object?> get props => [results, query];
}

class SearchEmpty extends SearchState {
  final String query;
  const SearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchError extends SearchState {
  final Failure failure;
  const SearchError(this.failure);

  @override
  List<Object?> get props => [failure];
}
