import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/data/datasources/paragraph_summary_remote_data_source.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/domain/entities/paragraph_summary_quest.dart';
import 'package:voxai_quest/features/reading/paragraph_summary/domain/repositories/paragraph_summary_repository.dart';

class ParagraphSummaryRepositoryImpl implements ParagraphSummaryRepository {
  final ParagraphSummaryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ParagraphSummaryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ParagraphSummaryQuest>>> getParagraphSummaryQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getParagraphSummaryQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

