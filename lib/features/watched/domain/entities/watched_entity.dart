import 'package:equatable/equatable.dart';

class WatchedEntity extends Equatable {
  final String id;
  final String userId;
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final double? rating;
  final String? comment;
  final DateTime watchedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WatchedEntity({
    required this.id,
    required this.userId,
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    this.rating,
    this.comment,
    required this.watchedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        mediaId,
        mediaType,
        title,
        posterPath,
        rating,
        comment,
        watchedAt,
        createdAt,
        updatedAt,
      ];
}

