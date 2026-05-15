import 'package:equatable/equatable.dart';

abstract class WatchlistEvent extends Equatable {
  const WatchlistEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchlistEvent extends WatchlistEvent {}

class AddToWatchlistEvent extends WatchlistEvent {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final int priority;
  final String? notes;

  const AddToWatchlistEvent({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.priority = 0,
    this.notes,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, title, posterPath, priority, notes];
}

class RemoveFromWatchlistEvent extends WatchlistEvent {
  final int mediaId;
  final String mediaType;

  const RemoveFromWatchlistEvent({
    required this.mediaId,
    required this.mediaType,
  });

  @override
  List<Object?> get props => [mediaId, mediaType];
}

class UpdateWatchlistItemEvent extends WatchlistEvent {
  final int mediaId;
  final String mediaType;
  final int? priority;
  final String? notes;

  const UpdateWatchlistItemEvent({
    required this.mediaId,
    required this.mediaType,
    this.priority,
    this.notes,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, priority, notes];
}

class ToggleWatchlistEvent extends WatchlistEvent {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;

  const ToggleWatchlistEvent({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, title, posterPath];
}

