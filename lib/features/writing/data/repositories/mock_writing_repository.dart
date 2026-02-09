import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/writing/domain/repositories/writing_repository.dart';

class MockWritingRepository implements WritingRepository {
  @override
  Future<Either<Failure, WritingQuest>> getWritingQuest(int difficulty) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Right(
      WritingQuest(
        id: 'w1',
        instruction: 'Translate the following sentence to English.',
        difficulty: difficulty,
        prompt: 'Hola, ¿cómo estás?',
        expectedAnswer: 'Hello, how are you?',
      ),
    );
  }
}
