import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/essay_drafting/data/datasources/essay_drafting_remote_data_source.dart';
import 'package:voxai_quest/features/writing/essay_drafting/domain/entities/essay_drafting_quest.dart';
import 'package:voxai_quest/features/writing/essay_drafting/domain/repositories/essay_drafting_repository.dart';

class EssayDraftingRepositoryImpl implements EssayDraftingRepository {
  final EssayDraftingRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  EssayDraftingRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<EssayDraftingQuest>>> getEssayDraftingQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getEssayDraftingQuests(
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
