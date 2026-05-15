import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/favorite_entity.dart';
import '../repositories/favorites_repository.dart';

class GetFavorites implements UseCase<List<FavoriteEntity>, NoParams> {
  final FavoritesRepository repository;

  GetFavorites(this.repository);

  @override
  Future<Either<Failure, List<FavoriteEntity>>> call(NoParams params) async {
    return await repository.getFavorites();
  }
}

