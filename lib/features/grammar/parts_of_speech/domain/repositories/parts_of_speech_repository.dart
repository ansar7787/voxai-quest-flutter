import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/domain/entities/parts_of_speech_quest.dart';

abstract class PartsOfSpeechRepository {
  Future<Either<Failure, List<PartsOfSpeechQuest>>> getPartsOfSpeechQuests(int level);
}
