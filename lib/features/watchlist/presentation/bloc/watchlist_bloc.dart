import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/watchlist_entity.dart';
import '../../domain/usecases/add_to_watchlist.dart';
import '../../domain/usecases/check_is_in_watchlist.dart';
import '../../domain/usecases/get_watchlist.dart';
import '../../domain/usecases/remove_from_watchlist.dart';
import '../../domain/usecases/update_watchlist_item.dart';
import 'watchlist_event.dart';
import 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlist getWatchlist;
  final AddToWatchlist addToWatchlist;
  final RemoveFromWatchlist removeFromWatchlist;
  final UpdateWatchlistItem updateWatchlistItem;
  final CheckIsInWatchlist checkIsInWatchlist;

  WatchlistBloc({
    required this.getWatchlist,
    required this.addToWatchlist,
    required this.removeFromWatchlist,
    required this.updateWatchlistItem,
    required this.checkIsInWatchlist,
  }) : super(WatchlistInitial()) {
    on<LoadWatchlistEvent>(_onLoadWatchlist);
    on<AddToWatchlistEvent>(_onAddToWatchlist);
    on<RemoveFromWatchlistEvent>(_onRemoveFromWatchlist);
    on<UpdateWatchlistItemEvent>(_onUpdateWatchlistItem);
    on<ToggleWatchlistEvent>(_onToggleWatchlist);
  }

  Future<void> _onLoadWatchlist(
    LoadWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    emit(WatchlistLoading());

    final result = await getWatchlist(NoParams());

    result.fold(
      (failure) => emit(WatchlistError(failure.toString())),
      (watchlist) => emit(WatchlistLoaded(watchlist)),
    );
  }

  Future<void> _onAddToWatchlist(
    AddToWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    final currentState = state;
    final currentWatchlist = currentState is WatchlistLoaded
        ? currentState.watchlist
        : currentState is WatchlistActionSuccess
            ? currentState.watchlist
            : [];

    final result = await addToWatchlist(AddToWatchlistParams(
      mediaId: event.mediaId,
      mediaType: event.mediaType,
      title: event.title,
      posterPath: event.posterPath,
      priority: event.priority,
      notes: event.notes,
    ));

    result.fold(
      (failure) => emit(WatchlistError(failure.toString())),
      (item) {
        final updatedWatchlist = <WatchlistEntity>[item, ...currentWatchlist]
          ..sort((a, b) {
            if (a.priority != b.priority) {
              return b.priority.compareTo(a.priority);
            }
            return b.createdAt.compareTo(a.createdAt);
          });
        emit(WatchlistActionSuccess(
          message: 'Ajouté à la liste à voir',
          watchlist: updatedWatchlist,
        ));
      },
    );
  }

  Future<void> _onRemoveFromWatchlist(
    RemoveFromWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    final currentState = state;
    final currentWatchlist = currentState is WatchlistLoaded
        ? currentState.watchlist
        : currentState is WatchlistActionSuccess
            ? currentState.watchlist
            : [];

    final result = await removeFromWatchlist(RemoveFromWatchlistParams(
      mediaId: event.mediaId,
      mediaType: event.mediaType,
    ));

    result.fold(
      (failure) => emit(WatchlistError(failure.toString())),
      (_) {
        final updatedWatchlist = currentWatchlist
            .where((item) =>
                !(item.mediaId == event.mediaId &&
                    item.mediaType == event.mediaType))
            .cast<WatchlistEntity>()
            .toList();
        emit(WatchlistActionSuccess(
          message: 'Retiré de la liste',
          watchlist: updatedWatchlist,
        ));
      },
    );
  }

  Future<void> _onUpdateWatchlistItem(
    UpdateWatchlistItemEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    final currentState = state;
    final currentWatchlist = currentState is WatchlistLoaded
        ? currentState.watchlist
        : currentState is WatchlistActionSuccess
            ? currentState.watchlist
            : [];

    final result = await updateWatchlistItem(UpdateWatchlistItemParams(
      mediaId: event.mediaId,
      mediaType: event.mediaType,
      priority: event.priority,
      notes: event.notes,
    ));

    result.fold(
      (failure) => emit(WatchlistError(failure.toString())),
      (updatedItem) {
        final updatedWatchlist = currentWatchlist.map<WatchlistEntity>((item) {
          if (item.mediaId == event.mediaId &&
              item.mediaType == event.mediaType) {
            return updatedItem;
          }
          return item;
        }).toList()
          ..sort((a, b) {
            if (a.priority != b.priority) {
              return b.priority.compareTo(a.priority);
            }
            return b.createdAt.compareTo(a.createdAt);
          });
        emit(WatchlistActionSuccess(
          message: 'Liste mise à jour',
          watchlist: updatedWatchlist,
        ));
      },
    );
  }

  Future<void> _onToggleWatchlist(
    ToggleWatchlistEvent event,
    Emitter<WatchlistState> emit,
  ) async {
    final result = await checkIsInWatchlist(CheckIsInWatchlistParams(
      mediaId: event.mediaId,
      mediaType: event.mediaType,
    ));

    result.fold(
      (failure) => emit(WatchlistError(failure.toString())),
      (isInWatchlist) {
        if (isInWatchlist) {
          add(RemoveFromWatchlistEvent(
            mediaId: event.mediaId,
            mediaType: event.mediaType,
          ));
        } else {
          add(AddToWatchlistEvent(
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





