import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/domain/entities/speak_missing_word_quest.dart';

abstract class SpeakMissingWordRepository {
  Future<Either<Failure, List<SpeakMissingWordQuest>>> getSpeakMissingWordQuests(int level);
}
