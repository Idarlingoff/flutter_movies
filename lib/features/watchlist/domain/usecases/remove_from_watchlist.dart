import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/watchlist_repository.dart';

class RemoveFromWatchlist
    implements UseCase<void, RemoveFromWatchlistParams> {
  final WatchlistRepository repository;

  RemoveFromWatchlist(this.repository);

  @override
  Future<Either<Failure, void>> call(RemoveFromWatchlistParams params) async {
    return await repository.removeFromWatchlist(
      mediaId: params.mediaId,
      mediaType: params.mediaType,
    );
  }
}

class RemoveFromWatchlistParams {
  final int mediaId;
  final String mediaType;

  RemoveFromWatchlistParams({
    required this.mediaId,
    required this.mediaType,
  });
}

