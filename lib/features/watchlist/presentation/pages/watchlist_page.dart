import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../media/domain/entities/media.dart';
import '../../../media/presentation/pages/details_page.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';
import '../../domain/entities/watchlist_entity.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('À Voir'),
      ),
      body: BlocBuilder<WatchlistBloc, WatchlistState>(
        builder: (context, state) {
          if (state is WatchlistLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WatchlistError) {
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
                      context.read<WatchlistBloc>().add(LoadWatchlistEvent());
                    },
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          final watchlist = state is WatchlistLoaded
              ? state.watchlist
              : state is WatchlistActionSuccess
                  ? state.watchlist
                  : [];

          if (watchlist.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bookmark_border,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Votre liste est vide',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ajoutez des films et séries à voir',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: watchlist.length,
            itemBuilder: (context, index) {
              final item = watchlist[index];
              return _WatchlistItemCard(item: item);
            },
          );
        },
      ),
    );
  }
}

class _WatchlistItemCard extends StatelessWidget {
  final WatchlistEntity item;

  const _WatchlistItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final imageUrl = item.posterPath != null
        ? 'https://image.tmdb.org/t/p/w200${item.posterPath}'
        : null;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          final mediaType = item.mediaType == 'movie'
              ? MediaType.movie
              : MediaType.tv;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsPage(
                mediaId: item.mediaId,
                mediaType: mediaType,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: imageUrl,
                        width: 80,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.movie, size: 40),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          item.mediaType == 'movie' ? Icons.movie : Icons.tv,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.mediaType == 'movie' ? 'Film' : 'Série',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getPriorityColor(item.priority),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.priorityLabel,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (item.notes != null && item.notes!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        item.notes!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'remove') {
                    context.read<WatchlistBloc>().add(
                          RemoveFromWatchlistEvent(
                            mediaId: item.mediaId,
                            mediaType: item.mediaType,
                          ),
                        );
                  } else if (value == 'edit') {
                    _showEditDialog(context, item);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(width: 8),
                        Text('Modifier'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'remove',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Supprimer', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.red;
      case -1:
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  void _showEditDialog(BuildContext context, WatchlistEntity item) {
    int selectedPriority = item.priority;
    final notesController = TextEditingController(text: item.notes ?? '');

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Modifier'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Priorité:', style: TextStyle(fontWeight: FontWeight.bold)),
            StatefulBuilder(
              builder: (context, setState) => Column(
                children: [
                  RadioListTile<int>(
                    title: const Text('Haute'),
                    value: 1,
                    groupValue: selectedPriority,
                    onChanged: (value) {
                      setState(() => selectedPriority = value!);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Normale'),
                    value: 0,
                    groupValue: selectedPriority,
                    onChanged: (value) {
                      setState(() => selectedPriority = value!);
                    },
                  ),
                  RadioListTile<int>(
                    title: const Text('Basse'),
                    value: -1,
                    groupValue: selectedPriority,
                    onChanged: (value) {
                      setState(() => selectedPriority = value!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: notesController,
              decoration: const InputDecoration(
                labelText: 'Notes',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WatchlistBloc>().add(
                    UpdateWatchlistItemEvent(
                      mediaId: item.mediaId,
                      mediaType: item.mediaType,
                      priority: selectedPriority,
                      notes: notesController.text.trim().isEmpty
                          ? null
                          : notesController.text.trim(),
                    ),
                  );
              Navigator.pop(dialogContext);
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }
}


