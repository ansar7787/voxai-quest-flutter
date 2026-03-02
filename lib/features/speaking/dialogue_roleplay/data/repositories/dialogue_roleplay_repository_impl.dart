import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/data/datasources/dialogue_roleplay_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/domain/entities/dialogue_roleplay_quest.dart';
import 'package:voxai_quest/features/speaking/dialogue_roleplay/domain/repositories/dialogue_roleplay_repository.dart';

class DialogueRoleplayRepositoryImpl implements DialogueRoleplayRepository {
  final DialogueRoleplayRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DialogueRoleplayRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<DialogueRoleplayQuest>>> getDialogueRoleplayQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getDialogueRoleplayQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

