import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/watched_entity.dart';
import '../repositories/watched_repository.dart';

class AddToWatched implements UseCase<WatchedEntity, AddToWatchedParams> {
  final WatchedRepository repository;

  AddToWatched(this.repository);

  @override
  Future<Either<Failure, WatchedEntity>> call(AddToWatchedParams params) async {
    return await repository.addToWatched(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
      title: params.title,
      posterPath: params.posterPath,
    );
  }
}

class AddToWatchedParams {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;

  AddToWatchedParams({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });
}

