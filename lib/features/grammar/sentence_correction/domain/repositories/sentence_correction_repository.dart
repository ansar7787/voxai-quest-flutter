import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/domain/entities/sentence_correction_quest.dart';

abstract class SentenceCorrectionRepository {
  Future<Either<Failure, List<SentenceCorrectionQuest>>> getSentenceCorrectionQuests(int level);
}
