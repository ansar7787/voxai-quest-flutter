import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/data/datasources/speak_synonym_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/domain/entities/speak_synonym_quest.dart';
import 'package:voxai_quest/features/speaking/speak_synonym/domain/repositories/speak_synonym_repository.dart';

class SpeakSynonymRepositoryImpl implements SpeakSynonymRepository {
  final SpeakSynonymRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SpeakSynonymRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SpeakSynonymQuest>>> getSpeakSynonymQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSpeakSynonymQuests(
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
