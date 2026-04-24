import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/media.dart';
import '../bloc/media_bloc.dart';
import '../bloc/media_event.dart';
import '../bloc/media_state.dart';

class DetailsPage extends StatefulWidget {
  final int mediaId;
  final MediaType mediaType;

  const DetailsPage({
    super.key,
    required this.mediaId,
    required this.mediaType,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<MediaBloc>().add(
      GetMediaDetailsEvent(id: widget.mediaId, type: widget.mediaType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MediaBloc, MediaState>(
        builder: (context, state) {
          if (state is MediaLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MediaDetailsLoaded) {
            final details = state.details;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      details.title,
                      style: const TextStyle(
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                    background: details.backdropPath != null
                        ? CachedNetworkImage(
                            imageUrl: details.backdropUrl,
                            fit: BoxFit.cover,
                          )
                        : Container(color: Colors.grey),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (details.tagline != null && details.tagline!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Text(
                              details.tagline!,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[600],
                                  ),
                            ),
                          ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text(
                              details.voteAverage.toStringAsFixed(1),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '(${details.voteCount} votes)',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        if (details.genres.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: details.genres
                                .map((genre) => Chip(label: Text(genre.name)))
                                .toList(),
                          ),
                        const SizedBox(height: 16),
                        if (details.runtime != null)
                          Text(
                            'Durée: ${details.runtime} minutes',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        if (details.numberOfSeasons != null)
                          Text(
                            '${details.numberOfSeasons} saisons',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        const SizedBox(height: 16),
                        Text(
                          'Synopsis',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          details.overview ?? 'Pas de synopsis disponible',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Ajouter aux favoris
                              },
                              icon: const Icon(Icons.favorite_border),
                              label: const Text('Favoris'),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Ajouter à la watchlist
                              },
                              icon: const Icon(Icons.bookmark_border),
                              label: const Text('Watchlist'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (state is MediaError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MediaBloc>().add(
                            GetMediaDetailsEvent(id: widget.mediaId, type: widget.mediaType),
                          );
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

