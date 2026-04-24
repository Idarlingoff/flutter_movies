import 'package:equatable/equatable.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/media_details.dart';

abstract class MediaState extends Equatable {
  const MediaState();

  @override
  List<Object?> get props => [];
}

class MediaInitial extends MediaState {}

class MediaLoading extends MediaState {}

class MediaLoaded extends MediaState {
  final List<Media> media;
  final bool hasMore;

  const MediaLoaded({
    required this.media,
    this.hasMore = true,
  });

  @override
  List<Object?> get props => [media, hasMore];
}

class MediaDetailsLoaded extends MediaState {
  final MediaDetails details;
  final List<Media> recommendations;

  const MediaDetailsLoaded({
    required this.details,
    this.recommendations = const [],
  });

  @override
  List<Object?> get props => [details, recommendations];
}

class MediaError extends MediaState {
  final String message;

  const MediaError(this.message);

  @override
  List<Object?> get props => [message];
}

