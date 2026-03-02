import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/data/datasources/speak_missing_word_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/domain/entities/speak_missing_word_quest.dart';
import 'package:voxai_quest/features/speaking/speak_missing_word/domain/repositories/speak_missing_word_repository.dart';

class SpeakMissingWordRepositoryImpl implements SpeakMissingWordRepository {
  final SpeakMissingWordRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SpeakMissingWordRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SpeakMissingWordQuest>>>
  getSpeakMissingWordQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSpeakMissingWordQuests(
          level,
        );
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}
