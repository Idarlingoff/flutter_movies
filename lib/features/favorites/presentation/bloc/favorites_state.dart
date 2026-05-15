import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_entity.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<FavoriteEntity> favorites;

  const FavoritesLoaded(this.favorites);

  bool isInFavorites(int mediaId, String mediaType) {
    return favorites.any(
      (fav) => fav.mediaId == mediaId && fav.mediaType == mediaType,
    );
  }

  @override
  List<Object?> get props => [favorites];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

class FavoriteActionSuccess extends FavoritesState {
  final String message;
  final List<FavoriteEntity> favorites;

  const FavoriteActionSuccess({
    required this.message,
    required this.favorites,
  });

  bool isInFavorites(int mediaId, String mediaType) {
    return favorites.any(
      (fav) => fav.mediaId == mediaId && fav.mediaType == mediaType,
    );
  }

  @override
  List<Object?> get props => [message, favorites];
}

