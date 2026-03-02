import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/writing/writing_email/data/datasources/writing_email_remote_data_source.dart';
import 'package:voxai_quest/features/writing/writing_email/domain/entities/writing_email_quest.dart';
import 'package:voxai_quest/features/writing/writing_email/domain/repositories/writing_email_repository.dart';

class WritingEmailRepositoryImpl implements WritingEmailRepository {
  final WritingEmailRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WritingEmailRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<WritingEmailQuest>>> getWritingEmailQuests(
    int level,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getWritingEmailQuests(
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
