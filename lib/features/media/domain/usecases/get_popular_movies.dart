import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media.dart';
import '../repositories/media_repository.dart';

class GetPopularMovies implements UseCase<List<Media>, int> {
  final MediaRepository repository;

  GetPopularMovies(this.repository);

  @override
  Future<Either<Failure, List<Media>>> call(int page) async {
    return await repository.getPopularMovies(page: page);
  }
}

