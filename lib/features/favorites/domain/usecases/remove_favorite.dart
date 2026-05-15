import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

class RemoveFavorite implements UseCase<void, RemoveFavoriteParams> {
  final FavoritesRepository repository;

  RemoveFavorite(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFavoriteParams params) async {
    return await repository.removeFavorite(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
    );
  }
}

class RemoveFavoriteParams {
  final int mediaId;
  final String mediaType;

  RemoveFavoriteParams({
    required this.mediaId,
    required this.mediaType,
  });
}

