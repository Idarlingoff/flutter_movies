import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/media.dart';
import '../repositories/media_repository.dart';

class SearchMedia implements UseCase<List<Media>, SearchParams> {
  final MediaRepository repository;

  SearchMedia(this.repository);

  @override
  Future<Either<Failure, List<Media>>> call(SearchParams params) async {
    return await repository.searchMedia(params.query, page: params.page);
  }
}

class SearchParams extends Equatable {
  final String query;
  final int page;

  const SearchParams({
    required this.query,
    this.page = 1,
  });

  @override
  List<Object?> get props => [query, page];
}

