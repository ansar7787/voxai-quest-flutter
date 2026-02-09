import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/grammar/domain/entities/grammar_quest.dart';
import 'package:voxai_quest/features/grammar/domain/repositories/grammar_repository.dart';

class GetGrammarQuest implements UseCase<GrammarQuest, int> {
  final GrammarRepository repository;

  GetGrammarQuest(this.repository);

  @override
  Future<Either<Failure, GrammarQuest>> call(int difficulty) async {
    return await repository.getGrammarQuest(difficulty);
  }
}
