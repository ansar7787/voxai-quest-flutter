import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class UpdateKidsMascot implements UseCase<void, String> {
  final AuthRepository repository;

  UpdateKidsMascot(this.repository);

  @override
  Future<Either<Failure, void>> call(String mascotId) async {
    return await repository.updateKidsMascot(mascotId);
  }
}
