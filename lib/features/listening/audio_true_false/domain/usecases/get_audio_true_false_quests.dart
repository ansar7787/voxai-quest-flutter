import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/audio_true_false/domain/entities/audio_true_false_quest.dart';
import 'package:voxai_quest/features/listening/audio_true_false/domain/repositories/audio_true_false_repository.dart';

class GetAudioTrueFalseQuests {
  final AudioTrueFalseRepository repository;

  GetAudioTrueFalseQuests(this.repository);

  Future<Either<Failure, List<AudioTrueFalseQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
