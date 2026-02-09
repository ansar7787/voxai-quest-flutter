import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserCoins implements UseCase<void, int> {
  final AuthRepository repository;

  UpdateUserCoins(this.repository);

  @override
  Future<Either<Failure, void>> call(int newCoins) async {
    return await repository.updateUserCoins(newCoins);
  }
}
