import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/sound_image_match/domain/entities/sound_image_match_quest.dart';

abstract class SoundImageMatchRepository {
  Future<Either<Failure, List<SoundImageMatchQuest>>> getQuests(int level);
}
