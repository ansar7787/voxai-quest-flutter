import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/domain/entities/flashcards_quest.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/domain/repositories/flashcards_repository.dart';

class GetFlashcardsQuests {
  final FlashcardsRepository repository;

  GetFlashcardsQuests(this.repository);

  Future<Either<Failure, List<FlashcardsQuest>>> call(int level) async {
    return await repository.getFlashcardsQuests(level);
  }
}
