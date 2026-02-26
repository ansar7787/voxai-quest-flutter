import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/grammar/domain/entities/grammar_quest.dart';
import 'package:voxai_quest/features/grammar/domain/repositories/grammar_repository.dart';
import 'package:voxai_quest/features/speaking/domain/usecases/get_speaking_quest.dart'; // For QuestParams

class GetGrammarQuest implements UseCase<List<GrammarQuest>, QuestParams> {
  final GrammarRepository repository;

  GetGrammarQuest(this.repository);

  @override
  Future<Either<Failure, List<GrammarQuest>>> call(QuestParams params) async {
    return await repository.getGrammarQuest(
      gameType: params.gameType,
      level: params.level,
    );
  }
}
