import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class UseHint extends UseCase<void, NoParams> {
  final AuthRepository repository;

  UseHint(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.useHint();
  }
}
