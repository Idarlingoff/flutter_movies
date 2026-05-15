import 'package:equatable/equatable.dart';

class WatchlistEntity extends Equatable {
  final String id;
  final String userId;
  final int mediaId;
  final String mediaType;
  final String title;
  final String? posterPath;
  final int priority;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WatchlistEntity({
    required this.id,
    required this.userId,
    required this.mediaId,
    required this.mediaType,
    required this.title,
    this.posterPath,
    required this.priority,
    this.notes,
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
        priority,
        notes,
        createdAt,
        updatedAt,
      ];

  String get priorityLabel {
    switch (priority) {
      case 1:
        return 'Haute';
      case -1:
        return 'Basse';
      default:
        return 'Normale';
    }
  }
}

