import '../../domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.userId,
    required super.mediaId,
    required super.mediaType,
    required super.title,
    super.posterPath,
    required super.createdAt,
  });

  factory FavoriteModel.fromJson(Map<String, dynamic> json) {
    return FavoriteModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mediaId: json['media_id'] as int,
      mediaType: json['media_type'] as String,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_id': mediaId,
      'media_type': mediaType,
      'title': title,
      'poster_path': posterPath,
    };
  }
}

