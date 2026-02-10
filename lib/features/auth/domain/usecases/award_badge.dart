import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class AwardBadge implements UseCase<void, String> {
  final AuthRepository repository;

  AwardBadge(this.repository);

  @override
  Future<Either<Failure, void>> call(String badgeId) async {
    try {
      await repository.awardBadge(badgeId);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
