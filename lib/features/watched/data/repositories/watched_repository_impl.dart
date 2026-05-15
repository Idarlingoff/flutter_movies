import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/watched_entity.dart';
import '../../domain/repositories/watched_repository.dart';
import '../datasources/watched_remote_datasource.dart';

class WatchedRepositoryImpl implements WatchedRepository {
  final WatchedRemoteDataSource remoteDataSource;

  WatchedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WatchedEntity>>> getWatched() async {
    try {
      final watched = await remoteDataSource.getWatched();
      return Right(watched);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WatchedEntity>> addToWatched({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
  }) async {
    try {
      final watched = await remoteDataSource.addToWatched(
        mediaId: mediaId,
        mediaType: mediaType,
        title: title,
        posterPath: posterPath,
      );
      return Right(watched);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWatched({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      await remoteDataSource.removeFromWatched(
        mediaId: mediaId,
        mediaType: mediaType,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isWatched({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final isWatched = await remoteDataSource.isWatched(
        mediaId: mediaId,
        mediaType: mediaType,
      );
      return Right(isWatched);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

