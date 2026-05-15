import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/favorite_entity.dart';

abstract class FavoritesRepository {
  Future<Either<Failure, List<FavoriteEntity>>> getFavorites();

  Future<Either<Failure, FavoriteEntity>> addFavorite({
    required int mediaId,
    required String mediaType,
    required String title,
    String? posterPath,
  });

  Future<Either<Failure, void>> removeFavorite({
    required int mediaId,
    required String mediaType,
  });

  Future<Either<Failure, bool>> isFavorite({
    required int mediaId,
    required String mediaType,
  });
}

