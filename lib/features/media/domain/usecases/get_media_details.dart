import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media.dart';
import '../entities/media_details.dart';
import '../repositories/media_repository.dart';

class GetMediaDetails implements UseCase<MediaDetails, MediaDetailsParams> {
  final MediaRepository repository;

  GetMediaDetails(this.repository);

  @override
  Future<Either<Failure, MediaDetails>> call(MediaDetailsParams params) async {
    return await repository.getMediaDetails(params.id, params.type);
  }
}

class MediaDetailsParams extends Equatable {
  final int id;
  final MediaType type;

  const MediaDetailsParams({
    required this.id,
    required this.type,
  });

  @override
  List<Object?> get props => [id, type];
}

