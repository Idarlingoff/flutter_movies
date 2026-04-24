import 'package:equatable/equatable.dart';
import '../../domain/entities/media.dart';

abstract class MediaEvent extends Equatable {
  const MediaEvent();

  @override
  List<Object?> get props => [];
}

class GetPopularMoviesEvent extends MediaEvent {
  final int page;

  const GetPopularMoviesEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class GetPopularTvShowsEvent extends MediaEvent {
  final int page;

  const GetPopularTvShowsEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class GetPopularAllEvent extends MediaEvent {
  final int page;

  const GetPopularAllEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class GetTrendingEvent extends MediaEvent {
  final int page;

  const GetTrendingEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class GetTrendingMoviesEvent extends MediaEvent {
  final int page;

  const GetTrendingMoviesEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class GetTrendingTvShowsEvent extends MediaEvent {
  final int page;

  const GetTrendingTvShowsEvent({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class SearchMediaEvent extends MediaEvent {
  final String query;
  final int page;

  const SearchMediaEvent({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, page];
}

class GetMediaDetailsEvent extends MediaEvent {
  final int id;
  final MediaType type;

  const GetMediaDetailsEvent({
    required this.id,
    required this.type,
  });

  @override
  List<Object?> get props => [id, type];
}

