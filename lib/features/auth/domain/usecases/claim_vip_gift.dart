import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class ClaimVipGift extends UseCase<void, NoParams> {
  final AuthRepository repository;

  ClaimVipGift(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.claimVipGift();
  }
}
