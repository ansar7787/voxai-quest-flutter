import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/domain/entities/sentence_order_reading_quest.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/domain/repositories/sentence_order_reading_repository.dart';

class GetSentenceOrderReadingQuests {
  final SentenceOrderReadingRepository repository;

  GetSentenceOrderReadingQuests(this.repository);

  Future<Either<Failure, List<SentenceOrderReadingQuest>>> call(
    int level,
  ) async {
    return await repository.getSentenceOrderReadingQuests(level);
  }
}
