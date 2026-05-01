import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_media_details.dart';
import '../../domain/usecases/get_popular_movies.dart';
import '../../domain/usecases/get_popular_tv_shows.dart';
import '../../domain/usecases/get_trending.dart';
import '../../domain/usecases/get_trending_movies.dart';
import '../../domain/usecases/get_trending_tv_shows.dart';
import '../../domain/usecases/search_media.dart';
import 'media_event.dart';
import 'media_state.dart';

export '../../domain/usecases/get_media_details.dart';
export '../../domain/usecases/search_media.dart';

class MediaBloc extends Bloc<MediaEvent, MediaState> {
  final GetPopularMovies getPopularMovies;
  final GetPopularTvShows getPopularTvShows;
  final GetTrending getTrending;
  final GetTrendingMovies getTrendingMovies;
  final GetTrendingTvShows getTrendingTvShows;
  final SearchMedia searchMedia;
  final GetMediaDetails getMediaDetails;

  MediaBloc({
    required this.getPopularMovies,
    required this.getPopularTvShows,
    required this.getTrending,
    required this.getTrendingMovies,
    required this.getTrendingTvShows,
    required this.searchMedia,
    required this.getMediaDetails,
  }) : super(MediaInitial()) {
    on<GetPopularMoviesEvent>(_onGetPopularMovies);
    on<GetPopularTvShowsEvent>(_onGetPopularTvShows);
    on<GetPopularAllEvent>(_onGetPopularAll);
    on<GetTrendingEvent>(_onGetTrending);
    on<GetTrendingMoviesEvent>(_onGetTrendingMovies);
    on<GetTrendingTvShowsEvent>(_onGetTrendingTvShows);
    on<SearchMediaEvent>(_onSearchMedia);
    on<GetMediaDetailsEvent>(_onGetMediaDetails);
  }

  Future<void> _onGetPopularMovies(
    GetPopularMoviesEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    final result = await getPopularMovies(event.page);
    result.fold(
      (failure) => emit(MediaError(failure.message)),
      (media) => emit(MediaLoaded(media: media)),
    );
  }

  Future<void> _onGetPopularTvShows(
    GetPopularTvShowsEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    final result = await getPopularTvShows(event.page);
    result.fold(
      (failure) => emit(MediaError(failure.message)),
      (media) => emit(MediaLoaded(media: media)),
    );
  }

  Future<void> _onGetPopularAll(
    GetPopularAllEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());

    final moviesResult = await getPopularMovies(event.page);
    final tvShowsResult = await getPopularTvShows(event.page);

    String? errorMessage;

    final List allMedia = [];

    moviesResult.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (movies) => allMedia.addAll(movies),
    );

    tvShowsResult.fold(
      (failure) {
        errorMessage = failure.message;
      },
      (tvShows) => allMedia.addAll(tvShows),
    );

    if (errorMessage != null && allMedia.isEmpty) {
      emit(MediaError(errorMessage!));
      return;
    }

    if (allMedia.isNotEmpty) {
      allMedia.sort((a, b) {
        final scoreA = a.voteAverage * a.voteCount;
        final scoreB = b.voteAverage * b.voteCount;
        return scoreB.compareTo(scoreA);
      });

      emit(MediaLoaded(media: allMedia.cast()));
    }
  }

  Future<void> _onGetTrending(
    GetTrendingEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    final result = await getTrending(event.page);
    result.fold(
      (failure) => emit(MediaError(failure.message)),
      (media) => emit(MediaLoaded(media: media)),
    );
  }

  Future<void> _onGetTrendingMovies(
    GetTrendingMoviesEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    final result = await getTrendingMovies(event.page);
    result.fold(
      (failure) => emit(MediaError(failure.message)),
      (media) => emit(MediaLoaded(media: media)),
    );
  }

  Future<void> _onGetTrendingTvShows(
    GetTrendingTvShowsEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    final result = await getTrendingTvShows(event.page);
    result.fold(
      (failure) => emit(MediaError(failure.message)),
      (media) => emit(MediaLoaded(media: media)),
    );
  }

  Future<void> _onSearchMedia(
    SearchMediaEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    final result = await searchMedia(
      SearchParams(query: event.query, page: event.page),
    );
    result.fold(
      (failure) => emit(MediaError(failure.message)),
      (media) => emit(MediaLoaded(media: media)),
    );
  }

  Future<void> _onGetMediaDetails(
    GetMediaDetailsEvent event,
    Emitter<MediaState> emit,
  ) async {
    emit(MediaLoading());
    final result = await getMediaDetails(
      MediaDetailsParams(id: event.id, type: event.type),
    );
    result.fold(
      (failure) => emit(MediaError(failure.message)),
      (details) => emit(MediaDetailsLoaded(details: details)),
    );
  }
}

