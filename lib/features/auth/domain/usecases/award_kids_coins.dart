import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class AwardKidsCoins extends UseCase<void, int> {
  final AuthRepository repository;

  AwardKidsCoins(this.repository);

  @override
  Future<Either<Failure, void>> call(int amount) async {
    return await repository.awardKidsCoins(amount);
  }
}
