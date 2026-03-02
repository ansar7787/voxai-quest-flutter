import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/audio_multiple_choice/domain/entities/audio_multiple_choice_quest.dart';

abstract class AudioMultipleChoiceRepository {
  Future<Either<Failure, List<AudioMultipleChoiceQuest>>> getQuests(int level);
}
