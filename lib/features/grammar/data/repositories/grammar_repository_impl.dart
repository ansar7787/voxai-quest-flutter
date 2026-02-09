import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/data/datasources/grammar_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/domain/entities/grammar_quest.dart';
import 'package:voxai_quest/features/grammar/domain/repositories/grammar_repository.dart';

class GrammarRepositoryImpl implements GrammarRepository {
  final GrammarRemoteDataSource remoteDataSource;

  GrammarRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, GrammarQuest>> getGrammarQuest(int difficulty) async {
    try {
      final remoteQuest = await remoteDataSource.getGrammarQuest(difficulty);
      return Right(remoteQuest);
    } on ServerException {
      return Left(ServerFailure('Failed to load grammar quest'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
