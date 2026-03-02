import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/audio_multiple_choice/data/datasources/audio_multiple_choice_remote_data_source.dart';
import 'package:voxai_quest/features/listening/audio_multiple_choice/domain/entities/audio_multiple_choice_quest.dart';
import 'package:voxai_quest/features/listening/audio_multiple_choice/domain/repositories/audio_multiple_choice_repository.dart';

class AudioMultipleChoiceRepositoryImpl implements AudioMultipleChoiceRepository {
  final AudioMultipleChoiceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AudioMultipleChoiceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AudioMultipleChoiceQuest>>> getQuests(int level) async {
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
