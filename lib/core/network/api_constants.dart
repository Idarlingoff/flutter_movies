class ApiConstants {

  static const String baseUrl = 'https://your-proxy-api.com/api';

  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p';

  static const String posterW185 = '$imageBaseUrl/w185';
  static const String posterW342 = '$imageBaseUrl/w342';
  static const String posterW500 = '$imageBaseUrl/w500';
  static const String backdropW780 = '$imageBaseUrl/w780';
  static const String backdropW1280 = '$imageBaseUrl/w1280';
  static const String posterOriginal = '$imageBaseUrl/original';

  static const String popularMovies = '/movie/popular';
  static const String popularTvShows = '/tv/popular';
  static const String trendingAll = '/trending/all/week';
  static const String trendingMovies = '/trending/movie/week';
  static const String trendingTvShows = '/trending/tv/week';
  static const String searchMovie = '/search/movie';
  static const String searchTv = '/search/tv';
  static const String movieDetails = '/movie';
  static const String tvDetails = '/tv';
  static const String movieRecommendations = '/movie/{movie_id}/recommendations';
  static const String tvRecommendations = '/tv/{tv_id}/recommendations';
}
