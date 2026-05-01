import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class UpdateProfile implements UseCase<UserEntity, UpdateProfileParams> {
  final AuthRepository repository;

  UpdateProfile(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UpdateProfileParams params) async {
    return await repository.updateProfile(
      displayName: params.displayName,
      avatarUrl: params.avatarUrl,
    );
  }
}

class UpdateProfileParams {
  final String? displayName;
  final String? avatarUrl;

  UpdateProfileParams({
    this.displayName,
    this.avatarUrl,
  });
}

