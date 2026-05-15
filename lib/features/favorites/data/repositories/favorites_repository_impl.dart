import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_remote_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesRemoteDataSource remoteDataSource;

  FavoritesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites() async {
    try {
      final favorites = await remoteDataSource.getFavorites();
      return Right(favorites);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FavoriteEntity>> addFavorite({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
  }) async {
    try {
      final favorite = await remoteDataSource.addFavorite(
        mediaId: mediaId,
        mediaType: mediaType,
        title: title,
        posterPath: posterPath,
      );
      return Right(favorite);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFavorite({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      await remoteDataSource.removeFavorite(
        mediaId: mediaId,
        mediaType: mediaType,
      );
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isFavorite({
    required int mediaId,
    required String mediaType,
  }) async {
    try {
      final isFavorite = await remoteDataSource.isFavorite(
        mediaId: mediaId,
        mediaType: mediaType,
      );
      return Right(isFavorite);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

