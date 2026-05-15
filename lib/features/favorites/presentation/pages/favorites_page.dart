import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../media/domain/entities/media.dart';
import '../../../media/presentation/pages/details_page.dart';
import '../bloc/favorites_bloc.dart';
import '../bloc/favorites_event.dart';
import '../bloc/favorites_state.dart';
import '../widgets/favorite_button.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes Favoris'),
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is FavoritesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FavoritesBloc>().add(LoadFavoritesEvent());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final favorites = state is FavoritesLoaded
              ? state.favorites
              : state is FavoriteActionSuccess
                  ? state.favorites
                  : [];

          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucun favori pour le moment',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez des films et séries à vos favoris',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              final imageUrl = favorite.posterPath != null
                  ? 'https://image.tmdb.org/t/p/w500${favorite.posterPath}'
                  : null;

              return GestureDetector(
                onTap: () {
                  final mediaType = favorite.mediaType == 'movie'
                      ? MediaType.movie
                      : MediaType.tv;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsPage(
                        mediaId: favorite.mediaId,
                        mediaType: mediaType,
                      ),
                    ),
                  );
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: imageUrl != null
                                ? CachedNetworkImage(
                                    imageUrl: imageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      color: Colors.grey[300],
                                      child: const Icon(
                                        Icons.image_not_supported,
                                        size: 48,
                                      ),
                                    ),
                                  )
                                : Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.movie,
                                      size: 48,
                                    ),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              favorite.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.5),
                            shape: BoxShape.circle,
                          ),
                          child: FavoriteButton(
                            mediaId: favorite.mediaId,
                            mediaType: favorite.mediaType,
                            title: favorite.title,
                            posterPath: favorite.posterPath,
                            size: 20,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 40,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                favorite.mediaType == 'movie'
                                    ? Icons.movie
                                    : Icons.tv,
                                size: 14,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                favorite.mediaType == 'movie'
                                    ? 'Film'
                                    : 'Série',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



