import '../../domain/entities/watchlist_entity.dart';

class WatchlistModel extends WatchlistEntity {
  const WatchlistModel({
    required super.id,
    required super.userId,
    required super.mediaId,
    required super.mediaType,
    required super.title,
    super.posterPath,
    required super.priority,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory WatchlistModel.fromJson(Map<String, dynamic> json) {
    return WatchlistModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      mediaId: json['media_id'] as int,
      mediaType: json['media_type'] as String,
      title: json['title'] as String,
      posterPath: json['poster_path'] as String?,
      priority: json['priority'] as int? ?? 0,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'media_id': mediaId,
      'media_type': mediaType,
      'title': title,
      'poster_path': posterPath,
      'priority': priority,
      'notes': notes,
    };
  }
}

