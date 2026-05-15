import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/watched_bloc.dart';
import '../bloc/watched_event.dart';
import '../bloc/watched_state.dart';
import 'rating_dialog.dart';

class WatchedButton extends StatelessWidget {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final double size;

  const WatchedButton({
    super.key,
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WatchedBloc, WatchedState>(
      listener: (context, state) {
        if (state is WatchedReadyToRate) {
          // Afficher le dialogue de notation
          showDialog(
            context: context,
            builder: (dialogContext) => RatingDialog(
              title: state.title,
              onSubmit: (rating, comment) {
                context.read<WatchedBloc>().add(AddToWatchedEvent(
                  mediaId: state.mediaId,
                  mediaType: state.mediaType,
                  title: state.title,
                  posterPath: state.posterPath,
                  rating: rating,
                  comment: comment,
                ));
              },
            ),
          );
        } else if (state is WatchedAddSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Ajouté aux films regardés'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is WatchedRemoveSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Retiré des films regardés'),
              duration: Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is WatchedError) {
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
        bool isWatched = false;

        if (state is WatchedLoaded) {
          isWatched = state.watched.any((item) =>
            item.mediaId == mediaId && item.mediaType == mediaType
          );
        }

        return IconButton(
          icon: Icon(
            isWatched ? Icons.check_circle : Icons.check_circle_outline,
            color: isWatched ? Colors.green : null,
            size: size,
          ),
          onPressed: () {
            context.read<WatchedBloc>().add(ToggleWatchedEvent(
                  mediaId: mediaId,
                  mediaType: mediaType,
                  title: title,
                  posterPath: posterPath,
                ));
          },
          tooltip: isWatched ? 'Marquer comme non vu' : 'Marquer comme vu',
        );
      },
    );
  }
}



