import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/core/utils/local_smart_tutor.dart';
import 'package:voxai_quest/features/auth/domain/repositories/auth_repository.dart';

class GetSmartCategory implements UseCase<String, NoParams> {
  final AuthRepository _authRepository;
  final LocalSmartTutor _smartTutor;

  GetSmartCategory({
    required AuthRepository authRepository,
    required LocalSmartTutor smartTutor,
  }) : _authRepository = authRepository,
       _smartTutor = smartTutor;

  @override
  Future<Either<Failure, String>> call(NoParams params) async {
    try {
      final result = await _authRepository.getCurrentUser();

      return result.fold(
        (failure) => const Right('reading'), // Default on failure
        (user) {
          if (user == null) return const Right('reading');
          final category = _smartTutor.suggestNextQuestCategory(user);
          return Right(category);
        },
      );
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
