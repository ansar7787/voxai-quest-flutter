import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/data/datasources/academic_word_remote_data_source.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/domain/entities/academic_word_quest.dart';
import 'package:voxai_quest/features/vocabulary/academic_word/domain/repositories/academic_word_repository.dart';

class AcademicWordRepositoryImpl implements AcademicWordRepository {
  final AcademicWordRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  AcademicWordRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AcademicWordQuest>>> getAcademicWordQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getAcademicWordQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

