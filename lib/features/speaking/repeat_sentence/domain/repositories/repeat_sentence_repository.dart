import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/domain/entities/repeat_sentence_quest.dart';

abstract class RepeatSentenceRepository {
  Future<Either<Failure, List<RepeatSentenceQuest>>> getRepeatSentenceQuests(
    int level,
  );
}
