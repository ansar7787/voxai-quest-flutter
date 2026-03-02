import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/data/datasources/parts_of_speech_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/domain/entities/parts_of_speech_quest.dart';
import 'package:voxai_quest/features/grammar/parts_of_speech/domain/repositories/parts_of_speech_repository.dart';

class PartsOfSpeechRepositoryImpl implements PartsOfSpeechRepository {
  final PartsOfSpeechRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PartsOfSpeechRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PartsOfSpeechQuest>>> getPartsOfSpeechQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getPartsOfSpeechQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

