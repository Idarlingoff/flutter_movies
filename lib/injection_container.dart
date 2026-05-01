import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/sign_in.dart';
import 'features/auth/domain/usecases/sign_out.dart';
import 'features/auth/domain/usecases/sign_up.dart';
import 'features/auth/domain/usecases/update_profile.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
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

  sl.registerFactory(
    () => AuthBloc(
      signIn: sl(),
      signUp: sl(),
      signOut: sl(),
      getCurrentUser: sl(),
      updateProfile: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetPopularMovies(sl()));
  sl.registerLazySingleton(() => GetPopularTvShows(sl()));
  sl.registerLazySingleton(() => GetTrending(sl()));
  sl.registerLazySingleton(() => GetTrendingMovies(sl()));
  sl.registerLazySingleton(() => GetTrendingTvShows(sl()));
  sl.registerLazySingleton(() => SearchMedia(sl()));
  sl.registerLazySingleton(() => GetMediaDetails(sl()));

  sl.registerLazySingleton(() => SignIn(sl()));
  sl.registerLazySingleton(() => SignUp(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));

  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<MediaRemoteDataSource>(
    () => MediaRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Supabase.instance.client);
}

