import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/daily_journal/data/datasources/daily_journal_remote_data_source.dart';
import 'package:voxai_quest/features/writing/daily_journal/domain/entities/daily_journal_quest.dart';
import 'package:voxai_quest/features/writing/daily_journal/domain/repositories/daily_journal_repository.dart';

class DailyJournalRepositoryImpl implements DailyJournalRepository {
  final DailyJournalRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DailyJournalRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DailyJournalQuest>>> getDailyJournalQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getDailyJournalQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

