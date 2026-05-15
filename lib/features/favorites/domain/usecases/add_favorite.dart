import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorites_repository.dart';

class AddFavorite implements UseCase<FavoriteEntity, AddFavoriteParams> {
  final FavoritesRepository repository;

  AddFavorite(this.repository);

  @override
  Future<Either<Failure, FavoriteEntity>> call(AddFavoriteParams params) async {
    return await repository.addFavorite(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
      title: params.title,
      posterPath: params.posterPath,
    );
  }
}

class AddFavoriteParams {
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;

  AddFavoriteParams({
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
  });
}

