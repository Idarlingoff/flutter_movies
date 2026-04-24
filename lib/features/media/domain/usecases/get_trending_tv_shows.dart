import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media.dart';
import '../repositories/media_repository.dart';

class GetTrendingTvShows implements UseCase<List<Media>, int> {
  final MediaRepository repository;

  GetTrendingTvShows(this.repository);

  @override
  Future<Either<Failure, List<Media>>> call(int page) async {
    return await repository.getTrendingTvShows(page: page);
  }
}

