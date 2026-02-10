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
    // 1. Get current user entity from repository stream (or separate method).
    // The repository exposes a Stream<UserEntity?>. We can grab the latest value.
    // However, Streams are async. Ideally we have a 'getCurrentUser' method that returns Future<UserEntity?>.
    // But AuthRepository only has `get user` stream.
    // Let's optimize: We can just listen to the first element of the stream.
    try {
      final user = await _authRepository.user.first;
      if (user == null) {
        return const Right('reading'); // Default for unauthenticated/loading
      }

      final category = _smartTutor.suggestNextQuestCategory(user);
      return Right(category);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
