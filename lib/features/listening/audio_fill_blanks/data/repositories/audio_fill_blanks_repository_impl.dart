import 'package:dartz/dartz.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/domain/entities/audio_fill_blanks_quest.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/domain/repositories/audio_fill_blanks_repository.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/data/datasources/audio_fill_blanks_remote_data_source.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';

class AudioFillBlanksRepositoryImpl implements AudioFillBlanksRepository {
  final AudioFillBlanksRemoteDataSource remoteDataSource;

  AudioFillBlanksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AudioFillBlanksQuest>>> getQuests(
    int level,
  ) async {
    try {
      final remoteQuests = await remoteDataSource.getQuests(level);
      return Right(remoteQuests);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message ?? 'Server Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
