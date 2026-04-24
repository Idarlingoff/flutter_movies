import '../../domain/entities/media.dart';
import '../../domain/entities/media_details.dart';

class GenreModel extends Genre {
  const GenreModel({required super.id, required super.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) {
    return GenreModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class MediaDetailsModel extends MediaDetails {
  const MediaDetailsModel({
    required super.id,
    required super.title,
    super.overview,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    super.releaseDate,
    required super.mediaType,
    super.genres,
    super.runtime,
    super.numberOfSeasons,
    super.numberOfEpisodes,
    super.status,
    super.tagline,
    super.productionCompanies,
  });

  factory MediaDetailsModel.fromJson(Map<String, dynamic> json, MediaType type) {
    return MediaDetailsModel(
      id: json['id'] as int,
      title: (json['title'] ?? json['name'] ?? '') as String,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      mediaType: type,
      genres: (json['genres'] as List<dynamic>?)
              ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      runtime: json['runtime'] as int?,
      numberOfSeasons: json['number_of_seasons'] as int?,
      numberOfEpisodes: json['number_of_episodes'] as int?,
      status: json['status'] as String?,
      tagline: json['tagline'] as String?,
      productionCompanies: (json['production_companies'] as List<dynamic>?)
              ?.map((e) => (e as Map<String, dynamic>)['name'] as String)
              .toList() ??
          [],
    );
  }
}

