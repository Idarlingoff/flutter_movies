import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  final String id;
  final String userId;
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final DateTime createdAt;

  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
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
        createdAt,
      ];
}

