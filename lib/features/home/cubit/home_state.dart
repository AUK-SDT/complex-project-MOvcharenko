import 'package:equatable/equatable.dart';
import '../../models/genre.dart';
import '../../models/movie.dart';
import '../../../core/utils/failures.dart';

enum HomeTab { movies, tvShows }

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<Movie> trending;
  final List<Movie> tvShows;
  final List<Genre> genres;
  final HomeTab activeTab;

  const HomeLoaded({
    required this.trending,
    required this.tvShows,
    required this.genres,
    this.activeTab = HomeTab.movies,
  });

  HomeLoaded copyWith({
    List<Movie>? trending,
    List<Movie>? tvShows,
    List<Genre>? genres,
    HomeTab? activeTab,
  }) =>
      HomeLoaded(
        trending: trending ?? this.trending,
        tvShows: tvShows ?? this.tvShows,
        genres: genres ?? this.genres,
        activeTab: activeTab ?? this.activeTab,
      );

  List<Movie> get activeList => activeTab == HomeTab.movies ? trending : tvShows;

  @override
  List<Object?> get props => [trending, tvShows, genres, activeTab];
}

class HomeError extends HomeState {
  final Failure failure;
  const HomeError(this.failure);

  @override
  List<Object?> get props => [failure];
}
