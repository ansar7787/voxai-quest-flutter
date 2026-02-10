import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class ForgotPassword implements UseCase<void, String> {
  final AuthRepository repository;

  ForgotPassword(this.repository);

  @override
  Future<Either<Failure, void>> call(String email) async {
    return await repository.sendPasswordResetEmail(email);
  }
}
