import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/daily_expression/domain/entities/daily_expression_quest.dart';

abstract class DailyExpressionRepository {
  Future<Either<Failure, List<DailyExpressionQuest>>> getDailyExpressionQuests(
    int level,
  );
}
