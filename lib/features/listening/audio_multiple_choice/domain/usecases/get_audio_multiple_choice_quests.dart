import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/audio_multiple_choice/domain/entities/audio_multiple_choice_quest.dart';
import 'package:voxai_quest/features/listening/audio_multiple_choice/domain/repositories/audio_multiple_choice_repository.dart';

class GetAudioMultipleChoiceQuests {
  final AudioMultipleChoiceRepository repository;

  GetAudioMultipleChoiceQuests(this.repository);

  Future<Either<Failure, List<AudioMultipleChoiceQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
