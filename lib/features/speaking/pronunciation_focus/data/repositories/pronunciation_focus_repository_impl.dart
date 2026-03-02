import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/data/datasources/pronunciation_focus_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/domain/entities/pronunciation_focus_quest.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/domain/repositories/pronunciation_focus_repository.dart';

class PronunciationFocusRepositoryImpl implements PronunciationFocusRepository {
  final PronunciationFocusRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PronunciationFocusRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<PronunciationFocusQuest>>>
  getPronunciationFocusQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getPronunciationFocusQuests(
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
