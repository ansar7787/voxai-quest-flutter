import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/domain/entities/sentence_order_reading_quest.dart';

abstract class SentenceOrderReadingRepository {
  Future<Either<Failure, List<SentenceOrderReadingQuest>>> getSentenceOrderReadingQuests(int level);
}
