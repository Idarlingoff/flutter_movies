import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watchlist_bloc.dart';
import '../bloc/watchlist_event.dart';
import '../bloc/watchlist_state.dart';

class WatchlistButton extends StatelessWidget {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final double size;

  const WatchlistButton({
    super.key,
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchlistBloc, WatchlistState>(
      listener: (context, state) {
        if (state is WatchlistActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is WatchlistError) {
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
        bool isInWatchlist = false;

        if (state is WatchlistLoaded) {
          isInWatchlist = state.isInWatchlist(mediaId, mediaType);
        } else if (state is WatchlistActionSuccess) {
          isInWatchlist = state.isInWatchlist(mediaId, mediaType);
        }

        return IconButton(
          icon: Icon(
            isInWatchlist ? Icons.bookmark : Icons.bookmark_border,
            color: isInWatchlist ? Colors.blue : null,
            size: size,
          ),
          onPressed: () {
            context.read<WatchlistBloc>().add(ToggleWatchlistEvent(
                  mediaId: mediaId,
                  mediaType: mediaType,
                  title: title,
                  posterPath: posterPath,
                ));
          },
          tooltip: isInWatchlist ? 'Retirer de la liste' : 'Ajouter à la liste à voir',
        );
      },
    );
  }
}

