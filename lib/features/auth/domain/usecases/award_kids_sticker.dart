import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class AwardKidsSticker extends UseCase<void, String> {
  final AuthRepository repository;

  AwardKidsSticker(this.repository);

  @override
  Future<Either<Failure, void>> call(String stickerId) async {
    return await repository.awardKidsSticker(stickerId);
  }
}
