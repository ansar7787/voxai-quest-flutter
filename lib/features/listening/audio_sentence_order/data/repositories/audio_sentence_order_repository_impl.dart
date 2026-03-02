import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/data/datasources/audio_sentence_order_remote_data_source.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/domain/entities/audio_sentence_order_quest.dart';
import 'package:voxai_quest/features/listening/audio_sentence_order/domain/repositories/audio_sentence_order_repository.dart';

class AudioSentenceOrderRepositoryImpl implements AudioSentenceOrderRepository {
  final AudioSentenceOrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AudioSentenceOrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AudioSentenceOrderQuest>>> getQuests(int level) async {
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
