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
import 'features/favorites/data/datasources/favorites_remote_datasource.dart';
import 'features/favorites/data/repositories/favorites_repository_impl.dart';
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/favorites/domain/usecases/add_favorite.dart';
import 'features/favorites/domain/usecases/check_is_favorite.dart';
import 'features/favorites/domain/usecases/get_favorites.dart';
import 'features/favorites/domain/usecases/remove_favorite.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';
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
import 'features/watchlist/data/datasources/watchlist_remote_datasource.dart';
import 'features/watchlist/data/repositories/watchlist_repository_impl.dart';
import 'features/watchlist/domain/repositories/watchlist_repository.dart';
import 'features/watchlist/domain/usecases/add_to_watchlist.dart';
import 'features/watchlist/domain/usecases/check_is_in_watchlist.dart';
import 'features/watchlist/domain/usecases/get_watchlist.dart';
import 'features/watchlist/domain/usecases/remove_from_watchlist.dart';
import 'features/watchlist/domain/usecases/update_watchlist_item.dart';
import 'features/watchlist/presentation/bloc/watchlist_bloc.dart';
import 'features/watched/data/datasources/watched_remote_datasource.dart';
import 'features/watched/data/repositories/watched_repository_impl.dart';
import 'features/watched/domain/repositories/watched_repository.dart';
import 'features/watched/domain/usecases/add_to_watched.dart';
import 'features/watched/domain/usecases/check_is_watched.dart';
import 'features/watched/domain/usecases/get_watched.dart';
import 'features/watched/domain/usecases/remove_from_watched.dart';
import 'features/watched/presentation/bloc/watched_bloc.dart';

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

  sl.registerFactory(
    () => FavoritesBloc(
      getFavorites: sl(),
      addFavorite: sl(),
      removeFavorite: sl(),
      checkIsFavorite: sl(),
    ),
  );

  sl.registerFactory(
    () => WatchlistBloc(
      getWatchlist: sl(),
      addToWatchlist: sl(),
      removeFromWatchlist: sl(),
      updateWatchlistItem: sl(),
      checkIsInWatchlist: sl(),
    ),
  );

  sl.registerFactory(
    () => WatchedBloc(
      getWatched: sl(),
      addToWatched: sl(),
      removeFromWatched: sl(),
      checkIsWatched: sl(),
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

  sl.registerLazySingleton(() => GetFavorites(sl()));
  sl.registerLazySingleton(() => AddFavorite(sl()));
  sl.registerLazySingleton(() => RemoveFavorite(sl()));
  sl.registerLazySingleton(() => CheckIsFavorite(sl()));

  sl.registerLazySingleton(() => GetWatchlist(sl()));
  sl.registerLazySingleton(() => AddToWatchlist(sl()));
  sl.registerLazySingleton(() => RemoveFromWatchlist(sl()));
  sl.registerLazySingleton(() => UpdateWatchlistItem(sl()));
  sl.registerLazySingleton(() => CheckIsInWatchlist(sl()));

  sl.registerLazySingleton(() => GetWatched(sl()));
  sl.registerLazySingleton(() => AddToWatched(sl()));
  sl.registerLazySingleton(() => RemoveFromWatched(sl()));
  sl.registerLazySingleton(() => CheckIsWatched(sl()));

  sl.registerLazySingleton<MediaRepository>(
    () => MediaRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<FavoritesRepository>(
    () => FavoritesRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<WatchedRepository>(
    () => WatchedRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton<MediaRemoteDataSource>(
    () => MediaRemoteDataSourceImpl(dio: sl()),
  );

  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<FavoritesRemoteDataSource>(
    () => FavoritesRemoteDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<WatchlistRemoteDataSource>(
    () => WatchlistRemoteDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton<WatchedRemoteDataSource>(
    () => WatchedRemoteDataSourceImpl(supabaseClient: sl()),
  );

  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => Supabase.instance.client);
}

