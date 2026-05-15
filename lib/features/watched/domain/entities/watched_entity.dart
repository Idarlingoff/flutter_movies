import 'package:equatable/equatable.dart';

class WatchedEntity extends Equatable {
  final String id;
  final String userId;
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final DateTime watchedAt;
  final DateTime createdAt;

  const WatchedEntity({
    required this.id,
    required this.userId,
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    required this.watchedAt,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        mediaId,
        mediaType,
        title,
        posterPath,
        watchedAt,
        createdAt,
      ];
}

