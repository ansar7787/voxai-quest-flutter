import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/clause_connector/domain/entities/clause_connector_quest.dart';
import 'package:voxai_quest/features/grammar/clause_connector/domain/repositories/clause_connector_repository.dart';

class GetClauseConnectorQuests {
  final ClauseConnectorRepository repository;

  GetClauseConnectorQuests(this.repository);

  Future<Either<Failure, List<ClauseConnectorQuest>>> call(int level) async {
    return await repository.getClauseConnectorQuests(level);
  }
}
