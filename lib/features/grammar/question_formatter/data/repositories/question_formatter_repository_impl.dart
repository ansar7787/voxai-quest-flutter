import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/question_formatter/data/datasources/question_formatter_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/question_formatter/domain/entities/question_formatter_quest.dart';
import 'package:voxai_quest/features/grammar/question_formatter/domain/repositories/question_formatter_repository.dart';

class QuestionFormatterRepositoryImpl implements QuestionFormatterRepository {
  final QuestionFormatterRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  QuestionFormatterRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<QuestionFormatterQuest>>>
  getQuestionFormatterQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getQuestionFormatterQuests(
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
