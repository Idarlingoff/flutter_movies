import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/watchlist_entity.dart';
import '../repositories/watchlist_repository.dart';

class AddToWatchlist implements UseCase<WatchlistEntity, AddToWatchlistParams> {
  final WatchlistRepository repository;

  AddToWatchlist(this.repository);

  @override
  Future<Either<Failure, WatchlistEntity>> call(
      AddToWatchlistParams params) async {
    return await repository.addToWatchlist(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
      title: params.title,
      posterPath: params.posterPath,
      priority: params.priority,
      notes: params.notes,
    );
  }
}

class AddToWatchlistParams {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final int priority;
  final String? notes;

  AddToWatchlistParams({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.priority = 0,
    this.notes,
  });
}

