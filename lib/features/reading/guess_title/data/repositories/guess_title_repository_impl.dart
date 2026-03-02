import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/reading/guess_title/data/datasources/guess_title_remote_data_source.dart';
import 'package:voxai_quest/features/reading/guess_title/domain/entities/guess_title_quest.dart';
import 'package:voxai_quest/features/reading/guess_title/domain/repositories/guess_title_repository.dart';

class GuessTitleRepositoryImpl implements GuessTitleRepository {
  final GuessTitleRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  GuessTitleRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<GuessTitleQuest>>> getGuessTitleQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getGuessTitleQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

