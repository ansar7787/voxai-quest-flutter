import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/sound_image_match/domain/entities/sound_image_match_quest.dart';
import 'package:voxai_quest/features/listening/sound_image_match/domain/repositories/sound_image_match_repository.dart';

class GetSoundImageMatchQuests {
  final SoundImageMatchRepository repository;

  GetSoundImageMatchQuests(this.repository);

  Future<Either<Failure, List<SoundImageMatchQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
