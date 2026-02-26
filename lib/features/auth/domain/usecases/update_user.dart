import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class UpdateUser extends UseCase<void, UpdateUserParams> {
  final AuthRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserParams params) async {
    return await repository.updateUser(params.user);
  }
}

class UpdateUserParams {
  final UserEntity user;

  const UpdateUserParams({required this.user});
}
