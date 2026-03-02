import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/domain/entities/speak_synonym_quest.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/domain/repositories/speak_synonym_repository.dart';

class GetSpeakSynonymQuests {
  final SpeakSynonymRepository repository;

  GetSpeakSynonymQuests(this.repository);

  Future<Either<Failure, List<SpeakSynonymQuest>>> call(int level) async {
    return await repository.getSpeakSynonymQuests(level);
  }
}
