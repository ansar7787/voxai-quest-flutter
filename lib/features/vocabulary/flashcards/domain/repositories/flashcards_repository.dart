import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/domain/entities/flashcards_quest.dart';

abstract class FlashcardsRepository {
  Future<Either<Failure, List<FlashcardsQuest>>> getFlashcardsQuests(int level);
}
