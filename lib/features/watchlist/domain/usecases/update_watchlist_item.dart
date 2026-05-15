import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/watchlist_entity.dart';
import '../repositories/watchlist_repository.dart';

class UpdateWatchlistItem
    implements UseCase<WatchlistEntity, UpdateWatchlistItemParams> {
  final WatchlistRepository repository;

  UpdateWatchlistItem(this.repository);

  @override
  Future<Either<Failure, WatchlistEntity>> call(
      UpdateWatchlistItemParams params) async {
    return await repository.updateWatchlistItem(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
      priority: params.priority,
      notes: params.notes,
    );
  }
}

class UpdateWatchlistItemParams {
  final int mediaId;
  final String mediaType;
  final int? priority;
  final String? notes;

  UpdateWatchlistItemParams({
    required this.mediaId,
    required this.mediaType,
    this.priority,
    this.notes,
  });
}

