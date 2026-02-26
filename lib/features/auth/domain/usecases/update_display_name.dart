import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class UpdateDisplayName extends UseCase<void, String> {
  final AuthRepository repository;

  UpdateDisplayName(this.repository);

  @override
  Future<Either<Failure, void>> call(String displayName) async {
    return await repository.updateDisplayName(displayName);
  }
}
