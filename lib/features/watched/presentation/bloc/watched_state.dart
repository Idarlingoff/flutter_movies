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

class WatchedAddSuccess extends WatchedState {
  final WatchedEntity watched;

  const WatchedAddSuccess({required this.watched});

  @override
  List<Object?> get props => [watched];
}

class WatchedRemoveSuccess extends WatchedState {}

