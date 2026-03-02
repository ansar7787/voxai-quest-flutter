import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/domain/entities/fast_speech_decoder_quest.dart';

abstract class FastSpeechDecoderRepository {
  Future<Either<Failure, List<FastSpeechDecoderQuest>>> getQuests(int level);
}
