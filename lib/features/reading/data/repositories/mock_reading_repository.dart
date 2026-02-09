import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/domain/entities/reading_quest.dart';
import 'package:voxai_quest/features/reading/domain/repositories/reading_repository.dart';

class MockReadingRepository implements ReadingRepository {
  @override
  Future<Either<Failure, ReadingQuest>> getReadingQuest(int difficulty) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      ReadingQuest(
        id: 'r1',
        instruction: 'Read the passage and answer the question.',
        difficulty: difficulty,
        passage: 'The quick brown fox jumps over the lazy dog.',
        options: ['Fox', 'Dog', 'Cat', 'Bird'],
        correctOptionIndex: 0,
      ),
    );
  }
}
