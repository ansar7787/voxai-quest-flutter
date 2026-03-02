import 'package:dartz/dartz.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/domain/entities/audio_fill_blanks_quest.dart';
import 'package:voxai_quest/core/error/failures.dart';

abstract class AudioFillBlanksRepository {
  Future<Either<Failure, List<AudioFillBlanksQuest>>> getQuests(int level);
}
