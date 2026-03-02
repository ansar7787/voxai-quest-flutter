import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/domain/entities/parts_of_speech_quest.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/domain/repositories/parts_of_speech_repository.dart';

class GetPartsOfSpeechQuests {
  final PartsOfSpeechRepository repository;

  GetPartsOfSpeechQuests(this.repository);

  Future<Either<Failure, List<PartsOfSpeechQuest>>> call(int level) async {
    return await repository.getPartsOfSpeechQuests(level);
  }
}
