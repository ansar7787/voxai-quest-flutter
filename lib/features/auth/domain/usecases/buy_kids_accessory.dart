import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class BuyKidsAccessory implements UseCase<void, BuyKidsAccessoryParams> {
  final AuthRepository repository;

  BuyKidsAccessory(this.repository);

  @override
  Future<Either<Failure, void>> call(BuyKidsAccessoryParams params) async {
    return await repository.buyKidsAccessory(params.accessoryId, params.cost);
  }
}

class BuyKidsAccessoryParams {
  final String accessoryId;
  final int cost;

  BuyKidsAccessoryParams({required this.accessoryId, required this.cost});
}
