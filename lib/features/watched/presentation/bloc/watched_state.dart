import 'package:equatable/equatable.dart';
import '../../domain/entities/watched_entity.dart';

abstract class WatchedState extends Equatable {
  const WatchedState();

  @override
  List<Object?> get props => [];
}

class WatchedInitial extends WatchedState {}

class WatchedLoading extends WatchedState {}

class WatchedLoaded extends WatchedState {
  final List<WatchedEntity> watched;

  const WatchedLoaded({required this.watched});

  @override
  List<Object?> get props => [watched];
}

class WatchedError extends WatchedState {
  final String message;

  const WatchedError({required this.message});

  @override
  List<Object?> get props => [message];
}

class WatchedCheckResult extends WatchedState {
  final bool isWatched;
  final int mediaId;
  final String mediaType;

  const WatchedCheckResult({
    required this.isWatched,
    required this.mediaId,
    required this.mediaType,
  });

  @override
  List<Object?> get props => [isWatched, mediaId, mediaType];
}

class WatchedReadyToRate extends WatchedState {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;

  const WatchedReadyToRate({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, title, posterPath];
}

class WatchedAddSuccess extends WatchedState {
  final WatchedEntity watched;

  const WatchedAddSuccess({required this.watched});

  @override
  List<Object?> get props => [watched];
}

class WatchedUpdateSuccess extends WatchedState {
  final WatchedEntity watched;

  const WatchedUpdateSuccess({required this.watched});

  @override
  List<Object?> get props => [watched];
}

class WatchedRemoveSuccess extends WatchedState {}

