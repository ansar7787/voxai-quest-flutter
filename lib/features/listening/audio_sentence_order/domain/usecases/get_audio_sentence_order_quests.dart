import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/domain/entities/audio_sentence_order_quest.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/domain/repositories/audio_sentence_order_repository.dart';

class GetAudioSentenceOrderQuests {
  final AudioSentenceOrderRepository repository;

  GetAudioSentenceOrderQuests(this.repository);

  Future<Either<Failure, List<AudioSentenceOrderQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
