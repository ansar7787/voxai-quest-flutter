import 'package:voxai_quest/features/vocabulary/domain/repositories/vocabulary_repository.dart';
import 'package:voxai_quest/features/vocabulary/domain/entities/vocabulary_quest.dart';

class GetVocabularyQuests {
  final VocabularyRepository repository;

  GetVocabularyQuests(this.repository);

  Future<List<VocabularyQuest>> call(String gameType, int level) async {
    return await repository.getVocabularyQuests(gameType, level);
  }
}
