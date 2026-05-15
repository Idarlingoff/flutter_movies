import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/watchlist_entity.dart';
import '../../domain/repositories/watchlist_repository.dart';
import '../datasources/watchlist_remote_datasource.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistRemoteDataSource remoteDataSource;

  WatchlistRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<WatchlistEntity>>> getWatchlist() async {
    try {
      final watchlist = await remoteDataSource.getWatchlist();
      return Right(watchlist);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WatchlistEntity>> addToWatchlist({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
    int priority = 0,
    String? notes,
  }) async {
    try {
      final item = await remoteDataSource.addToWatchlist(
        mediaId: mediaId,
        mediaType: mediaType,
        title: title,
        posterPath: posterPath,
        priority: priority,
        notes: notes,
      );
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, WatchlistEntity>> updateWatchlistItem({
    required int mediaId,
    required String mediaType,
    int? priority,
    String? notes,
  }) async {
    try {
      final item = await remoteDataSource.updateWatchlistItem(
        mediaId: mediaId,
        mediaType: mediaType,
        priority: priority,
        notes: notes,
      );
      return Right(item);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWatchlist({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      await remoteDataSource.removeFromWatchlist(
        mediaId: mediaId,
        mediaType: mediaType,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isInWatchlist({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final isIn = await remoteDataSource.isInWatchlist(
        mediaId: mediaId,
        mediaType: mediaType,
      );
      return Right(isIn);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

