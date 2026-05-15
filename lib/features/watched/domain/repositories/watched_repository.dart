import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/watched_entity.dart';

abstract class WatchedRepository {
  Future<Either<Failure, List<WatchedEntity>>> getWatched();

  Future<Either<Failure, WatchedEntity>> addToWatched({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
    double? rating,
    String? comment,
  });

  Future<Either<Failure, WatchedEntity>> updateWatched({
    required int mediaId,
    required String mediaType,
    double? rating,
    String? comment,
  });

  Future<Either<Failure, void>> removeFromWatched({
    required int mediaId,
    required String mediaType,
  });

  Future<Either<Failure, bool>> isWatched({
    required int mediaId,
    required String mediaType,
  });
}

