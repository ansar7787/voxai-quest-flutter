import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/data/datasources/short_answer_writing_remote_data_source.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/domain/entities/short_answer_writing_quest.dart';
import 'package:voxai_quest/features/writing/short_answer_writing/domain/repositories/short_answer_writing_repository.dart';

class ShortAnswerWritingRepositoryImpl implements ShortAnswerWritingRepository {
  final ShortAnswerWritingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ShortAnswerWritingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ShortAnswerWritingQuest>>> getShortAnswerWritingQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getShortAnswerWritingQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

