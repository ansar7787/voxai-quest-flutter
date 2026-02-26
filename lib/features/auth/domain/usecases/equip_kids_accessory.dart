import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class EquipKidsAccessory implements UseCase<void, String?> {
  final AuthRepository repository;

  EquipKidsAccessory(this.repository);

  @override
  Future<Either<Failure, void>> call(String? accessoryId) async {
    return await repository.equipKidsAccessory(accessoryId);
  }
}
