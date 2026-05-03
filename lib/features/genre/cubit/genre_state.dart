import 'package:equatable/equatable.dart';
import '../../models/movie.dart';
import '../../models/genre.dart';
import '../../../core/utils/failures.dart';

abstract class GenreState extends Equatable {
  const GenreState();

  @override
  List<Object?> get props => [];
}

class GenreInitial extends GenreState {
  const GenreInitial();
}

class GenreLoading extends GenreState {
  const GenreLoading();
}

class GenreLoaded extends GenreState {
  final Genre genre;
  final List<Movie> movies;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final int currentPage;

  const GenreLoaded({
    required this.genre,
    required this.movies,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.currentPage = 1,
  });

  GenreLoaded copyWith({
    Genre? genre,
    List<Movie>? movies,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    int? currentPage,
  }) =>
      GenreLoaded(
        genre: genre ?? this.genre,
        movies: movies ?? this.movies,
        isLoadingMore: isLoadingMore ?? this.isLoadingMore,
        hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
        currentPage: currentPage ?? this.currentPage,
      );

  @override
  List<Object?> get props => [genre, movies, isLoadingMore, hasReachedEnd, currentPage];
}

class GenreError extends GenreState {
  final Failure failure;
  const GenreError(this.failure);

  @override
  List<Object?> get props => [failure];
}
