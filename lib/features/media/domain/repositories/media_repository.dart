import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/media.dart';
import '../entities/media_details.dart';

abstract class MediaRepository {
  Future<Either<Failure, List<Media>>> getPopularMovies({int page = 1});
  Future<Either<Failure, List<Media>>> getPopularTvShows({int page = 1});
  Future<Either<Failure, List<Media>>> getTrending({int page = 1});
  Future<Either<Failure, List<Media>>> getTrendingMovies({int page = 1});
  Future<Either<Failure, List<Media>>> getTrendingTvShows({int page = 1});
  Future<Either<Failure, List<Media>>> searchMedia(String query, {int page = 1});
  Future<Either<Failure, MediaDetails>> getMediaDetails(int id, MediaType type);
  Future<Either<Failure, List<Media>>> getRecommendations(int id, MediaType type);
}

