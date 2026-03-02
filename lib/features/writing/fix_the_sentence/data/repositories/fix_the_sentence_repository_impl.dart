import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/data/datasources/fix_the_sentence_remote_data_source.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/domain/entities/fix_the_sentence_quest.dart';
import 'package:voxai_quest/features/writing/fix_the_sentence/domain/repositories/fix_the_sentence_repository.dart';

class FixTheSentenceRepositoryImpl implements FixTheSentenceRepository {
  final FixTheSentenceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FixTheSentenceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FixTheSentenceQuest>>> getFixTheSentenceQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getFixTheSentenceQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

