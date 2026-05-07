import 'package:equatable/equatable.dart';
import '../../models/media_item.dart';
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
  final MediaItem item;
  final List<MediaItem> similar;
  final bool isInWatchlist;

  const DetailLoaded({
    required this.item,
    this.similar = const [],
    this.isInWatchlist = false,
  });

  DetailLoaded copyWith({
    MediaItem? item,
    List<MediaItem>? similar,
    bool? isInWatchlist,
  }) =>
      DetailLoaded(
        item: item ?? this.item,
        similar: similar ?? this.similar,
        isInWatchlist: isInWatchlist ?? this.isInWatchlist,
      );

  @override
  List<Object?> get props => [item, similar, isInWatchlist];
}

class DetailError extends DetailState {
  final Failure failure;
  const DetailError(this.failure);

  @override
  List<Object?> get props => [failure];
}
