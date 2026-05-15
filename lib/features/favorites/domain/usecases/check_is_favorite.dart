import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/favorites_repository.dart';

class CheckIsFavorite implements UseCase<bool, CheckIsFavoriteParams> {
  final FavoritesRepository repository;

  CheckIsFavorite(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckIsFavoriteParams params) async {
    return await repository.isFavorite(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
    );
  }
}

class CheckIsFavoriteParams {
  final int mediaId;
  final String mediaType;

  CheckIsFavoriteParams({
    required this.mediaId,
    required this.mediaType,
  });
}

