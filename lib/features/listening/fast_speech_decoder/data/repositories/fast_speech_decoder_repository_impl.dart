import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/data/datasources/fast_speech_decoder_remote_data_source.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/domain/entities/fast_speech_decoder_quest.dart';
import 'package:voxai_quest/features/listening/fast_speech_decoder/domain/repositories/fast_speech_decoder_repository.dart';

class FastSpeechDecoderRepositoryImpl implements FastSpeechDecoderRepository {
  final FastSpeechDecoderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FastSpeechDecoderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FastSpeechDecoderQuest>>> getQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
