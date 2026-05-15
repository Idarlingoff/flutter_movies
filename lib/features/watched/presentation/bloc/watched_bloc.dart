import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/add_to_watched.dart';
import '../../domain/usecases/check_is_watched.dart';
import '../../domain/usecases/get_watched.dart';
import '../../domain/usecases/remove_from_watched.dart';
import '../../domain/usecases/update_watched.dart';
import 'watched_event.dart';
import 'watched_state.dart';

class WatchedBloc extends Bloc<WatchedEvent, WatchedState> {
  final GetWatched getWatched;
  final AddToWatched addToWatched;
  final RemoveFromWatched removeFromWatched;
  final CheckIsWatched checkIsWatched;
  final UpdateWatched updateWatched;

  WatchedBloc({
    required this.getWatched,
    required this.addToWatched,
    required this.removeFromWatched,
    required this.checkIsWatched,
    required this.updateWatched,
  }) : super(WatchedInitial()) {
    on<LoadWatchedEvent>(_onLoadWatched);
    on<ToggleWatchedEvent>(_onToggleWatched);
    on<AddToWatchedEvent>(_onAddToWatched);
    on<UpdateWatchedEvent>(_onUpdateWatched);
    on<RemoveFromWatchedEvent>(_onRemoveFromWatched);
    on<CheckIsWatchedEvent>(_onCheckIsWatched);
  }

  Future<void> _onToggleWatched(
    ToggleWatchedEvent event,
    Emitter<WatchedState> emit,
  ) async {
    // Vérifier si le film est déjà regardé
    final checkResult = await checkIsWatched(
      CheckIsWatchedParams(
        mediaId: event.mediaId,
        mediaType: event.mediaType,
      ),
    );

    await checkResult.fold(
      (failure) async => emit(WatchedError(message: failure.message)),
      (isWatched) async {
        if (isWatched) {
          // Retirer de la liste
          final result = await removeFromWatched(
            RemoveFromWatchedParams(
              mediaId: event.mediaId,
              mediaType: event.mediaType,
            ),
          );
          result.fold(
            (failure) => emit(WatchedError(message: failure.message)),
            (_) {
              emit(WatchedRemoveSuccess());
              add(LoadWatchedEvent());
            },
          );
        } else {
          // Le film n'est pas encore regardé, on va demander la notation
          emit(WatchedReadyToRate(
            mediaId: event.mediaId,
            mediaType: event.mediaType,
            title: event.title,
            posterPath: event.posterPath,
          ));
        }
      },
    );
  }

  Future<void> _onLoadWatched(
    LoadWatchedEvent event,
    Emitter<WatchedState> emit,
  ) async {
    emit(WatchedLoading());

    final result = await getWatched(NoParams());

    result.fold(
      (failure) => emit(WatchedError(message: failure.message)),
      (watched) => emit(WatchedLoaded(watched: watched)),
    );
  }

  Future<void> _onAddToWatched(
    AddToWatchedEvent event,
    Emitter<WatchedState> emit,
  ) async {
    final result = await addToWatched(
      AddToWatchedParams(
        mediaId: event.mediaId,
        mediaType: event.mediaType,
        title: event.title,
        posterPath: event.posterPath,
        rating: event.rating,
        comment: event.comment,
      ),
    );

    result.fold(
      (failure) => emit(WatchedError(message: failure.message)),
      (watched) {
        emit(WatchedAddSuccess(watched: watched));
        add(LoadWatchedEvent());
      },
    );
  }

  Future<void> _onUpdateWatched(
    UpdateWatchedEvent event,
    Emitter<WatchedState> emit,
  ) async {
    final result = await updateWatched(
      UpdateWatchedParams(
        mediaId: event.mediaId,
        mediaType: event.mediaType,
        rating: event.rating,
        comment: event.comment,
      ),
    );

    result.fold(
      (failure) => emit(WatchedError(message: failure.message)),
      (watched) {
        emit(WatchedUpdateSuccess(watched: watched));
        add(LoadWatchedEvent());
      },
    );
  }

  Future<void> _onRemoveFromWatched(
    RemoveFromWatchedEvent event,
    Emitter<WatchedState> emit,
  ) async {
    final result = await removeFromWatched(
      RemoveFromWatchedParams(
        mediaId: event.mediaId,
        mediaType: event.mediaType,
      ),
    );

    result.fold(
      (failure) => emit(WatchedError(message: failure.message)),
      (_) {
        emit(WatchedRemoveSuccess());
        add(LoadWatchedEvent());
      },
    );
  }

  Future<void> _onCheckIsWatched(
    CheckIsWatchedEvent event,
    Emitter<WatchedState> emit,
  ) async {
    final result = await checkIsWatched(
      CheckIsWatchedParams(
        mediaId: event.mediaId,
        mediaType: event.mediaType,
      ),
    );

    result.fold(
      (failure) => emit(WatchedError(message: failure.message)),
      (isWatched) => emit(WatchedCheckResult(
        isWatched: isWatched,
        mediaId: event.mediaId,
        mediaType: event.mediaType,
      )),
    );
  }
}


