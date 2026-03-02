import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/domain/entities/speak_synonym_quest.dart';

abstract class SpeakSynonymRepository {
  Future<Either<Failure, List<SpeakSynonymQuest>>> getSpeakSynonymQuests(int level);
}
