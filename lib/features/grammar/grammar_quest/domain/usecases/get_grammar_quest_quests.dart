import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/domain/entities/grammar_quest_quest.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/domain/repositories/grammar_quest_repository.dart';

class GetGrammarQuestQuests {
  final GrammarQuestRepository repository;

  GetGrammarQuestQuests(this.repository);

  Future<Either<Failure, List<GrammarQuestQuest>>> call(int level) async {
    return await repository.getGrammarQuestQuests(level);
  }
}
