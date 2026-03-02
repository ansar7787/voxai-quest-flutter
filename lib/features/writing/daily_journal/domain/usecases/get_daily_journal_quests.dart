import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/writing/daily_journal/domain/entities/daily_journal_quest.dart';
import 'package:voxai_quest/features/writing/daily_journal/domain/repositories/daily_journal_repository.dart';

class GetDailyJournalQuests {
  final DailyJournalRepository repository;

  GetDailyJournalQuests(this.repository);

  Future<Either<Failure, List<DailyJournalQuest>>> call(int level) async {
    return await repository.getDailyJournalQuests(level);
  }
}
