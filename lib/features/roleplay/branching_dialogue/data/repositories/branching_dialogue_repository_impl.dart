import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/domain/entities/branching_dialogue_quest.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/domain/repositories/branching_dialogue_repository.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/data/datasources/branching_dialogue_remote_data_source.dart';

class BranchingDialogueRepositoryImpl implements BranchingDialogueRepository {
  final BranchingDialogueRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  BranchingDialogueRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<BranchingDialogueQuest>>> getBranchingDialogueQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getBranchingDialogueQuests(level);
        return Right(remoteQuests);
      } on ServerException {
        return Left(ServerFailure('Server error occurred'));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

