import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watched_repository.dart';

class RemoveFromWatched implements UseCase<void, RemoveFromWatchedParams> {
  final WatchedRepository repository;

  RemoveFromWatched(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromWatchedParams params) async {
    return await repository.removeFromWatched(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
    );
  }
}

class RemoveFromWatchedParams {
  final int mediaId;
  final String mediaType;

  RemoveFromWatchedParams({
    required this.mediaId,
    required this.mediaType,
  });
}

