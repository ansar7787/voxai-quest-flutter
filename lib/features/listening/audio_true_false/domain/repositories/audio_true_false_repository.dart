import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/audio_true_false/domain/entities/audio_true_false_quest.dart';

abstract class AudioTrueFalseRepository {
  Future<Either<Failure, List<AudioTrueFalseQuest>>> getQuests(int level);
}
