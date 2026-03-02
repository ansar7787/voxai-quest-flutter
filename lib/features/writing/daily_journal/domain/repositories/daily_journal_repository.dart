import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/daily_journal/domain/entities/daily_journal_quest.dart';

abstract class DailyJournalRepository {
  Future<Either<Failure, List<DailyJournalQuest>>> getDailyJournalQuests(
    int level,
  );
}
