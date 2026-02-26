import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class UpdateUserCoins implements UseCase<void, UpdateUserCoinsParams> {
  final AuthRepository repository;

  UpdateUserCoins(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateUserCoinsParams params) async {
    return await repository.updateUserCoins(
      params.amountChange,
      title: params.title,
      isEarned: params.isEarned,
    );
  }
}

class UpdateUserCoinsParams {
  final int amountChange;
  final String? title;
  final bool? isEarned;

  UpdateUserCoinsParams({
    required this.amountChange,
    this.title,
    this.isEarned,
  });
}
