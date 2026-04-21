import 'package:equatable/equatable.dart';
import '../models/watchlist_item.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();
  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {
  const WatchlistInitial();
}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistItem> items;
  final List<WatchlistItem> watched;
  final List<WatchlistItem> unwatched;

  WatchlistLoaded(List<WatchlistItem> all)
      : items = all,
        watched = all.where((i) => i.isWatched).toList(),
        unwatched = all.where((i) => !i.isWatched).toList();

  @override
  List<Object?> get props => [items];
}
