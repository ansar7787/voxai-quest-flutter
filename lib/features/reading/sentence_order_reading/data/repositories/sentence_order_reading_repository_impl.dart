import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/data/datasources/sentence_order_reading_remote_data_source.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/domain/entities/sentence_order_reading_quest.dart';
import 'package:voxai_quest/features/reading/sentence_order_reading/domain/repositories/sentence_order_reading_repository.dart';

class SentenceOrderReadingRepositoryImpl implements SentenceOrderReadingRepository {
  final SentenceOrderReadingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SentenceOrderReadingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SentenceOrderReadingQuest>>> getSentenceOrderReadingQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSentenceOrderReadingQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

