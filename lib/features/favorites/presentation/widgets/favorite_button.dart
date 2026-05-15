import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';

class FavoriteButton extends StatelessWidget {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final double size;

  const FavoriteButton({
    super.key,
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        if (state is FavoriteActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is FavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        bool isFavorite = false;

        if (state is FavoritesLoaded) {
          isFavorite = state.isInFavorites(mediaId, mediaType);
        } else if (state is FavoriteActionSuccess) {
          isFavorite = state.isInFavorites(mediaId, mediaType);
        }

        return IconButton(
          icon: Icon(
            isFavorite ? Icons.favorite : Icons.favorite_border,
            color: isFavorite ? Colors.red : null,
            size: size,
          ),
          onPressed: () {
            context.read<FavoritesBloc>().add(ToggleFavoriteEvent(
                  mediaId: mediaId,
                  mediaType: mediaType,
                  title: title,
                  posterPath: posterPath,
                ));
          },
          tooltip: isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris',
        );
      },
    );
  }
}

