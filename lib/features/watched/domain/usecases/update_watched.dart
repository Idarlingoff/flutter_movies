import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/watched_entity.dart';
import '../repositories/watched_repository.dart';

class UpdateWatched implements UseCase<WatchedEntity, UpdateWatchedParams> {
  final WatchedRepository repository;

  UpdateWatched(this.repository);

  @override
  Future<Either<Failure, WatchedEntity>> call(UpdateWatchedParams params) async {
    return await repository.updateWatched(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
      rating: params.rating,
      comment: params.comment,
    );
  }
}

class UpdateWatchedParams {
  final int mediaId;
  final String mediaType;
  final double? rating;
  final String? comment;

  UpdateWatchedParams({
    required this.mediaId,
    required this.mediaType,
    this.rating,
    this.comment,
  });
}

