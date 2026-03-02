import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/clause_connector/domain/entities/clause_connector_quest.dart';

abstract class ClauseConnectorRepository {
  Future<Either<Failure, List<ClauseConnectorQuest>>> getClauseConnectorQuests(
    int level,
  );
}
