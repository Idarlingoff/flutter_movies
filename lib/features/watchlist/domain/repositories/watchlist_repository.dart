import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/watchlist_entity.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<WatchlistEntity>>> getWatchlist();

  Future<Either<Failure, WatchlistEntity>> addToWatchlist({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
    int priority,
    String? notes,
  });

  Future<Either<Failure, WatchlistEntity>> updateWatchlistItem({
    required int mediaId,
    required String mediaType,
    int? priority,
    String? notes,
  });

  Future<Either<Failure, void>> removeFromWatchlist({
    required int mediaId,
    required String mediaType,
  });

  Future<Either<Failure, bool>> isInWatchlist({
    required int mediaId,
    required String mediaType,
  });
}

