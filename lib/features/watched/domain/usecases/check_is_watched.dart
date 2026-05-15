import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watched_repository.dart';

class CheckIsWatched implements UseCase<bool, CheckIsWatchedParams> {
  final WatchedRepository repository;

  CheckIsWatched(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckIsWatchedParams params) async {
    return await repository.isWatched(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
    );
  }
}

class CheckIsWatchedParams {
  final int mediaId;
  final String mediaType;

  CheckIsWatchedParams({
    required this.mediaId,
    required this.mediaType,
  });
}

