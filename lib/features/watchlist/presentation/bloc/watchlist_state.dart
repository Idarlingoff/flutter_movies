import 'package:equatable/equatable.dart';
import '../../domain/entities/watchlist_entity.dart';

abstract class WatchlistState extends Equatable {
  const WatchlistState();

  @override
  List<Object?> get props => [];
}

class WatchlistInitial extends WatchlistState {}

class WatchlistLoading extends WatchlistState {}

class WatchlistLoaded extends WatchlistState {
  final List<WatchlistEntity> watchlist;

  const WatchlistLoaded(this.watchlist);

  bool isInWatchlist(int mediaId, String mediaType) {
    return watchlist.any(
      (item) => item.mediaId == mediaId && item.mediaType == mediaType,
    );
  }

  @override
  List<Object?> get props => [watchlist];
}

class WatchlistError extends WatchlistState {
  final String message;

  const WatchlistError(this.message);

  @override
  List<Object?> get props => [message];
}

class WatchlistActionSuccess extends WatchlistState {
  final String message;
  final List<WatchlistEntity> watchlist;

  const WatchlistActionSuccess({
    required this.message,
    required this.watchlist,
  });

  bool isInWatchlist(int mediaId, String mediaType) {
    return watchlist.any(
      (item) => item.mediaId == mediaId && item.mediaType == mediaType,
    );
  }

  @override
  List<Object?> get props => [message, watchlist];
}

