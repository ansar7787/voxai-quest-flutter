import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/grammar_quest/domain/entities/grammar_quest_quest.dart';

abstract class GrammarQuestRepository {
  Future<Either<Failure, List<GrammarQuestQuest>>> getGrammarQuestQuests(
    int level,
  );
}
