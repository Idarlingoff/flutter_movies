import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/check_is_favorite.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/remove_favorite.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final GetFavorites getFavorites;
  final AddFavorite addFavorite;
  final RemoveFavorite removeFavorite;
  final CheckIsFavorite checkIsFavorite;

  FavoritesBloc({
    required this.getFavorites,
    required this.addFavorite,
    required this.removeFavorite,
    required this.checkIsFavorite,
  }) : super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    emit(FavoritesLoading());

    final result = await getFavorites(NoParams());

    result.fold(
      (failure) => emit(FavoritesError(failure.toString())),
      (favorites) => emit(FavoritesLoaded(favorites)),
    );
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    final currentFavorites = currentState is FavoritesLoaded
        ? currentState.favorites
        : <FavoriteEntity>[];

    final result = await addFavorite(AddFavoriteParams(
      mediaId: event.mediaId,
      mediaType: event.mediaType,
      title: event.title,
      posterPath: event.posterPath,
    ));

    result.fold(
      (failure) => emit(FavoritesError(failure.toString())),
      (favorite) {
        final updatedFavorites = [favorite, ...currentFavorites];
        emit(FavoriteActionSuccess(
          message: 'Ajouté aux favoris',
          favorites: updatedFavorites,
        ));
      },
    );
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final currentState = state;
    final currentFavorites = currentState is FavoritesLoaded
        ? currentState.favorites
        : currentState is FavoriteActionSuccess
            ? currentState.favorites
            : <FavoriteEntity>[];

    final result = await removeFavorite(RemoveFavoriteParams(
      mediaId: event.mediaId,
      mediaType: event.mediaType,
    ));

    result.fold(
      (failure) => emit(FavoritesError(failure.toString())),
      (_) {
        final updatedFavorites = currentFavorites
            .where((fav) =>
                !(fav.mediaId == event.mediaId && fav.mediaType == event.mediaType))
            .toList();
        emit(FavoriteActionSuccess(
          message: 'Retiré des favoris',
          favorites: updatedFavorites,
        ));
      },
    );
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    final result = await checkIsFavorite(CheckIsFavoriteParams(
      mediaId: event.mediaId,
      mediaType: event.mediaType,
    ));

    result.fold(
      (failure) => emit(FavoritesError(failure.toString())),
      (isFavorite) {
        if (isFavorite) {
          add(RemoveFavoriteEvent(
            mediaId: event.mediaId,
            mediaType: event.mediaType,
          ));
        } else {
          add(AddFavoriteEvent(
            mediaId: event.mediaId,
            mediaType: event.mediaType,
            title: event.title,
            posterPath: event.posterPath,
          ));
        }
      },
    );
  }
}


