import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/domain/entities/speaking_quest.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/speaking_repository.dart';

class MockSpeakingRepository implements SpeakingRepository {
  @override
  Future<Either<Failure, SpeakingQuest>> getSpeakingQuest(
    int difficulty,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      SpeakingQuest(
        id: 's1',
        instruction: 'Pronounce the word below clearly.',
        difficulty: difficulty,
        textToSpeak: 'Antigravity',
      ),
    );
  }
}
