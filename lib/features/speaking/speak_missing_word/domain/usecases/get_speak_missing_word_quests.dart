import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/domain/entities/speak_missing_word_quest.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/domain/repositories/speak_missing_word_repository.dart';

class GetSpeakMissingWordQuests {
  final SpeakMissingWordRepository repository;

  GetSpeakMissingWordQuests(this.repository);

  Future<Either<Failure, List<SpeakMissingWordQuest>>> call(int level) async {
    return await repository.getSpeakMissingWordQuests(level);
  }
}
