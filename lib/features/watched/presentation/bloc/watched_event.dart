import 'package:equatable/equatable.dart';

abstract class WatchedEvent extends Equatable {
  const WatchedEvent();

  @override
  List<Object?> get props => [];
}

class LoadWatchedEvent extends WatchedEvent {}

class ToggleWatchedEvent extends WatchedEvent {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;

  const ToggleWatchedEvent({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, title, posterPath];
}

class AddToWatchedEvent extends WatchedEvent {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final double? rating;
  final String? comment;

  const AddToWatchedEvent({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, title, posterPath, rating, comment];
}

class UpdateWatchedEvent extends WatchedEvent {
  final int mediaId;
  final String mediaType;
  final double? rating;
  final String? comment;

  const UpdateWatchedEvent({
    required this.mediaId,
    required this.mediaType,
    this.rating,
    this.comment,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, rating, comment];
}

class RemoveFromWatchedEvent extends WatchedEvent {
  final int mediaId;
  final String mediaType;

  const RemoveFromWatchedEvent({
    required this.mediaId,
    required this.mediaType,
  });

  @override
  List<Object?> get props => [mediaId, mediaType];
}

class CheckIsWatchedEvent extends WatchedEvent {
  final int mediaId;
  final String mediaType;

  const CheckIsWatchedEvent({
    required this.mediaId,
    required this.mediaType,
  });

  @override
  List<Object?> get props => [mediaId, mediaType];
}


