import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/watchlist_entity.dart';
import '../repositories/watchlist_repository.dart';

class GetWatchlist implements UseCase<List<WatchlistEntity>, NoParams> {
  final WatchlistRepository repository;

  GetWatchlist(this.repository);

  @override
  Future<Either<Failure, List<WatchlistEntity>>> call(NoParams params) async {
    return await repository.getWatchlist();
  }
}

