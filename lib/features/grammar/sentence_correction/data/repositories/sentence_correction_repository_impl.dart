import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/data/datasources/sentence_correction_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/domain/entities/sentence_correction_quest.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/domain/repositories/sentence_correction_repository.dart';

class SentenceCorrectionRepositoryImpl implements SentenceCorrectionRepository {
  final SentenceCorrectionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SentenceCorrectionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SentenceCorrectionQuest>>> getSentenceCorrectionQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSentenceCorrectionQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

