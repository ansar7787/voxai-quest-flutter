import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/voice_swap/data/datasources/voice_swap_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/voice_swap/domain/entities/voice_swap_quest.dart';
import 'package:voxai_quest/features/grammar/voice_swap/domain/repositories/voice_swap_repository.dart';

class VoiceSwapRepositoryImpl implements VoiceSwapRepository {
  final VoiceSwapRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  VoiceSwapRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<VoiceSwapQuest>>> getVoiceSwapQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getVoiceSwapQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

