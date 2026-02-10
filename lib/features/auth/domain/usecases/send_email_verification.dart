import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class SendEmailVerification implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  SendEmailVerification(this._repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await _repository.sendEmailVerification();
  }
}
