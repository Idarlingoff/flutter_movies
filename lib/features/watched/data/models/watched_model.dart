import '../../domain/entities/watched_entity.dart';

class WatchedModel extends WatchedEntity {
  const WatchedModel({
    required super.id,
    required super.userId,
    required super.mediaId,
    required super.mediaType,
    required super.title,
    super.posterPath,
    required super.watchedAt,
    required super.createdAt,
  });

  factory WatchedModel.fromJson(Map<String, dynamic> json) {
    return WatchedModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mediaId: json['media_id'] as int,
      mediaType: json['media_type'] as String,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      watchedAt: DateTime.parse(json['watched_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'media_id': mediaId,
      'media_type': mediaType,
      'title': title,
      'poster_path': posterPath,
      'watched_at': watchedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}


