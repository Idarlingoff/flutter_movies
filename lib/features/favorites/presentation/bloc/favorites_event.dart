import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class AddFavoriteEvent extends FavoritesEvent {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;

  const AddFavoriteEvent({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, title, posterPath];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final int mediaId;
  final String mediaType;

  const RemoveFavoriteEvent({
    required this.mediaId,
    required this.mediaType,
  });

  @override
  List<Object?> get props => [mediaId, mediaType];
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;

  const ToggleFavoriteEvent({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });

  @override
  List<Object?> get props => [mediaId, mediaType, title, posterPath];
}

