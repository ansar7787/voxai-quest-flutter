import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class UpdateProfilePicture extends UseCase<String, String> {
  final AuthRepository repository;

  UpdateProfilePicture(this.repository);

  @override
  Future<Either<Failure, String>> call(String filePath) async {
    return await repository.updateProfilePicture(filePath);
  }
}
