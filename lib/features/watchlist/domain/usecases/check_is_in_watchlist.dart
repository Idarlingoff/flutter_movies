import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watchlist_repository.dart';

class CheckIsInWatchlist implements UseCase<bool, CheckIsInWatchlistParams> {
  final WatchlistRepository repository;

  CheckIsInWatchlist(this.repository);

  @override
  Future<Either<Failure, bool>> call(CheckIsInWatchlistParams params) async {
    return await repository.isInWatchlist(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
    );
  }
}

class CheckIsInWatchlistParams {
  final int mediaId;
  final String mediaType;

  CheckIsInWatchlistParams({
    required this.mediaId,
    required this.mediaType,
  });
}

