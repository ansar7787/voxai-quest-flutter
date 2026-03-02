import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/daily_expression/domain/entities/daily_expression_quest.dart';
import 'package:voxai_quest/features/speaking/daily_expression/domain/repositories/daily_expression_repository.dart';

class GetDailyExpressionQuests {
  final DailyExpressionRepository repository;

  GetDailyExpressionQuests(this.repository);

  Future<Either<Failure, List<DailyExpressionQuest>>> call(int level) async {
    return await repository.getDailyExpressionQuests(level);
  }
}
