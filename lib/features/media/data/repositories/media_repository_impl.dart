import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/media.dart';
import '../../domain/entities/media_details.dart';
import '../../domain/repositories/media_repository.dart';
import '../datasources/media_remote_datasource.dart';

class MediaRepositoryImpl implements MediaRepository {
  final MediaRemoteDataSource remoteDataSource;

  MediaRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Media>>> getPopularMovies({int page = 1}) async {
    try {
      final movies = await remoteDataSource.getPopularMovies(page: page);
      return Right(movies);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> getPopularTvShows({int page = 1}) async {
    try {
      final tvShows = await remoteDataSource.getPopularTvShows(page: page);
      return Right(tvShows);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> getTrending({int page = 1}) async {
    try {
      final trending = await remoteDataSource.getTrending(page: page);
      return Right(trending);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> getTrendingMovies({int page = 1}) async {
    try {
      final trending = await remoteDataSource.getTrendingMovies(page: page);
      return Right(trending);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> getTrendingTvShows({int page = 1}) async {
    try {
      final trending = await remoteDataSource.getTrendingTvShows(page: page);
      return Right(trending);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> searchMedia(String query, {int page = 1}) async {
    try {
      final results = await remoteDataSource.searchMedia(query, page: page);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, MediaDetails>> getMediaDetails(int id, MediaType type) async {
    try {
      final details = await remoteDataSource.getMediaDetails(id, type);
      return Right(details);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Media>>> getRecommendations(int id, MediaType type) async {
    try {
      final recommendations = await remoteDataSource.getRecommendations(id, type);
      return Right(recommendations);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure('Unexpected error: $e'));
    }
  }
}

