import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/watched_entity.dart';
import '../repositories/watched_repository.dart';

class GetWatched implements UseCase<List<WatchedEntity>, NoParams> {
  final WatchedRepository repository;

  GetWatched(this.repository);

  @override
  Future<Either<Failure, List<WatchedEntity>>> call(NoParams params) async {
    return await repository.getWatched();
  }
}

