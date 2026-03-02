import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/domain/entities/fast_speech_decoder_quest.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/domain/repositories/fast_speech_decoder_repository.dart';

class GetFastSpeechDecoderQuests {
  final FastSpeechDecoderRepository repository;

  GetFastSpeechDecoderQuests(this.repository);

  Future<Either<Failure, List<FastSpeechDecoderQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
