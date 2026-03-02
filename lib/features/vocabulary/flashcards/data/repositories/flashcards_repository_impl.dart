import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/data/datasources/flashcards_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/domain/entities/flashcards_quest.dart';
import 'package:voxai_quest/features/vocabulary/flashcards/domain/repositories/flashcards_repository.dart';

class FlashcardsRepositoryImpl implements FlashcardsRepository {
  final FlashcardsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  FlashcardsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<FlashcardsQuest>>> getFlashcardsQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getFlashcardsQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

