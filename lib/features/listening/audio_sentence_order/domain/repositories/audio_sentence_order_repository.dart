import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/domain/entities/audio_sentence_order_quest.dart';

abstract class AudioSentenceOrderRepository {
  Future<Either<Failure, List<AudioSentenceOrderQuest>>> getQuests(int level);
}
