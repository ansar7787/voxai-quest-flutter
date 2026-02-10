import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/speaking/data/datasources/conversation_remote_data_source.dart';
import 'package:voxai_quest/features/speaking/domain/entities/conversation_quest.dart';
import 'package:voxai_quest/features/speaking/domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ConversationRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ConversationRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, ConversationQuest>> getConversationQuest(
    int difficulty,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuest = await remoteDataSource.getConversationQuest(
          difficulty,
        );
        return Right(remoteQuest);
      } on ServerException {
        return Left(ServerFailure('Failed to load conversation quest'));
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(ServerFailure('No internet connection'));
    }
  }
}
