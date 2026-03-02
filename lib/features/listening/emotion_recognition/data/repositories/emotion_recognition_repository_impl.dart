import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/data/datasources/emotion_recognition_remote_data_source.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/domain/entities/emotion_recognition_quest.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/domain/repositories/emotion_recognition_repository.dart';

class EmotionRecognitionRepositoryImpl implements EmotionRecognitionRepository {
  final EmotionRecognitionRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EmotionRecognitionRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EmotionRecognitionQuest>>> getQuests(int level) async {
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
