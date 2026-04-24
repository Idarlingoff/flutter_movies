import '../../domain/entities/media.dart';

class MediaModel extends Media {
  const MediaModel({
    required super.id,
    required super.title,
    super.overview,
    super.posterPath,
    super.backdropPath,
    required super.voteAverage,
    required super.voteCount,
    super.releaseDate,
    required super.mediaType,
    super.genreIds,
  });

  factory MediaModel.fromJson(Map<String, dynamic> json, MediaType type) {
    return MediaModel(
      id: json['id'] as int,
      title: (json['title'] ?? json['name'] ?? '') as String,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
      voteCount: json['vote_count'] as int? ?? 0,
      releaseDate: (json['release_date'] ?? json['first_air_date']) as String?,
      mediaType: type,
      genreIds: (json['genre_ids'] as List<dynamic>?)
              ?.map((e) => e as int)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'name': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'vote_count': voteCount,
      'release_date': releaseDate,
      'first_air_date': releaseDate,
      'genre_ids': genreIds,
      'media_type': mediaType == MediaType.movie ? 'movie' : 'tv',
    };
  }
}

