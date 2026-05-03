import 'package:equatable/equatable.dart';
import '../../models/movie.dart';
import '../../../core/utils/failures.dart';

abstract class DetailState extends Equatable {
  const DetailState();
  @override
  List<Object?> get props => [];
}

class DetailInitial extends DetailState {
  const DetailInitial();
}

class DetailLoading extends DetailState {
  const DetailLoading();
}

class DetailLoaded extends DetailState {
  final Movie movie;
  final List<Movie> similar;
  final bool isInWatchlist;

  const DetailLoaded({
    required this.movie,
    this.similar = const [],
    this.isInWatchlist = false,
  });

  DetailLoaded copyWith({
    Movie? movie,
    List<Movie>? similar,
    bool? isInWatchlist,
  }) =>
      DetailLoaded(
        movie: movie ?? this.movie,
        similar: similar ?? this.similar,
        isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      );

  @override
  List<Object?> get props => [movie, similar, isInWatchlist];
}

class DetailError extends DetailState {
  final Failure failure;
  const DetailError(this.failure);

  @override
  List<Object?> get props => [failure];
}
