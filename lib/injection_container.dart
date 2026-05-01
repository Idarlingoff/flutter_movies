import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'features/media/data/datasources/media_remote_datasource.dart';
import 'features/media/data/repositories/media_repository_impl.dart';
import 'features/media/domain/repositories/media_repository.dart';
import 'features/media/domain/usecases/get_media_details.dart';
import 'features/media/domain/usecases/get_popular_movies.dart';
import 'features/media/domain/usecases/get_popular_tv_shows.dart';
import 'features/media/domain/usecases/get_trending.dart';
import 'features/media/domain/usecases/get_trending_movies.dart';
import 'features/media/domain/usecases/get_trending_tv_shows.dart';
import 'features/media/domain/usecases/search_media.dart';
import 'features/media/presentation/bloc/media_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(
    () => MediaBloc(
      getPopularMovies: sl(),
      getPopularTvShows: sl(),
      getTrending: sl(),
      getTrendingMovies: sl(),
      getTrendingTvShows: sl(),
      searchMedia: sl(),
      getMediaDetails: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetPopularTvShows(sl()));
  sl.registerLazySingleton(() => GetTrending(sl()));
  sl.registerLazySingleton(() => GetTrendingMovies(sl()));
  sl.registerLazySingleton(() => GetTrendingTvShows(sl()));
  sl.registerLazySingleton(() => SearchMedia(sl()));
  sl.registerLazySingleton(() => GetMediaDetails(sl()));

  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<MediaRemoteDataSource>(
    () => MediaRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton(() => Dio());
}

