import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_constants.dart';
import '../../domain/entities/media.dart';
import '../models/media_details_model.dart';
import '../models/media_model.dart';

abstract class MediaRemoteDataSource {
  Future<List<MediaModel>> getPopularMovies({int page = 1});
  Future<List<MediaModel>> getPopularTvShows({int page = 1});
  Future<List<MediaModel>> getTrending({int page = 1});
  Future<List<MediaModel>> getTrendingMovies({int page = 1});
  Future<List<MediaModel>> getTrendingTvShows({int page = 1});
  Future<List<MediaModel>> searchMedia(String query, {int page = 1});
  Future<MediaDetailsModel> getMediaDetails(int id, MediaType type);
  Future<List<MediaModel>> getRecommendations(int id, MediaType type);
}

class MediaRemoteDataSourceImpl implements MediaRemoteDataSource {
  final Dio dio;

  MediaRemoteDataSourceImpl({required this.dio}) {
    final apiKey = dotenv.env['TMDB_API_KEY'];
    dio.options.baseUrl = ApiConstants.tmdbBaseUrl;
    dio.options.queryParameters = {'api_key': apiKey, 'language': 'fr-FR'};
  }

  @override
  Future<List<MediaModel>> getPopularMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.popularMovies,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .map((json) => MediaModel.fromJson(json, MediaType.movie))
            .toList();
      } else {
        throw ServerException('Failed to load popular movies');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<List<MediaModel>> getPopularTvShows({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.popularTvShows,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .map((json) => MediaModel.fromJson(json, MediaType.tv))
            .toList();
      } else {
        throw ServerException('Failed to load popular TV shows');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<List<MediaModel>> getTrending({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.trendingAll,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results.map((json) {
          final mediaType = json['media_type'] == 'movie'
              ? MediaType.movie
              : MediaType.tv;
          return MediaModel.fromJson(json, mediaType);
        }).toList();
      } else {
        throw ServerException('Failed to load trending');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<List<MediaModel>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.trendingMovies,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .map((json) => MediaModel.fromJson(json, MediaType.movie))
            .toList();
      } else {
        throw ServerException('Failed to load trending movies');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<List<MediaModel>> getTrendingTvShows({int page = 1}) async {
    try {
      final response = await dio.get(
        ApiConstants.trendingTvShows,
        queryParameters: {'page': page},
      );

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .map((json) => MediaModel.fromJson(json, MediaType.tv))
            .toList();
      } else {
        throw ServerException('Failed to load trending TV shows');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<List<MediaModel>> searchMedia(String query, {int page = 1}) async {
    try {
      final movieResponse = await dio.get(
        ApiConstants.searchMovie,
        queryParameters: {'query': query, 'page': page},
      );

      final tvResponse = await dio.get(
        ApiConstants.searchTv,
        queryParameters: {'query': query, 'page': page},
      );

      final List<MediaModel> results = [];

      if (movieResponse.statusCode == 200) {
        final movieResults = movieResponse.data['results'] as List;
        results.addAll(movieResults
            .map((json) => MediaModel.fromJson(json, MediaType.movie)));
      }

      if (tvResponse.statusCode == 200) {
        final tvResults = tvResponse.data['results'] as List;
        results.addAll(
            tvResults.map((json) => MediaModel.fromJson(json, MediaType.tv)));
      }

      results.sort((a, b) {
        final scoreA = a.voteAverage * a.voteCount;
        final scoreB = b.voteAverage * b.voteCount;
        return scoreB.compareTo(scoreA);
      });

      return results;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<MediaDetailsModel> getMediaDetails(int id, MediaType type) async {
    try {
      final endpoint = type == MediaType.movie
          ? '${ApiConstants.movieDetails}/$id'
          : '${ApiConstants.tvDetails}/$id';

      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        return MediaDetailsModel.fromJson(response.data, type);
      } else {
        throw ServerException('Failed to load media details');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }

  @override
  Future<List<MediaModel>> getRecommendations(int id, MediaType type) async {
    try {
      final endpoint = type == MediaType.movie
          ? ApiConstants.movieRecommendations.replaceAll('{movie_id}', '$id')
          : ApiConstants.tvRecommendations.replaceAll('{tv_id}', '$id');

      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final results = response.data['results'] as List;
        return results
            .map((json) => MediaModel.fromJson(json, type))
            .toList();
      } else {
        throw ServerException('Failed to load recommendations');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Network error');
    }
  }
}

