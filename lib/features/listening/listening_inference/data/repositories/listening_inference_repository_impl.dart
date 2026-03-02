import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/listening/listening_inference/data/datasources/listening_inference_remote_data_source.dart';
import 'package:voxai_quest/features/listening/listening_inference/domain/entities/listening_inference_quest.dart';
import 'package:voxai_quest/features/listening/listening_inference/domain/repositories/listening_inference_repository.dart';

class ListeningInferenceRepositoryImpl implements ListeningInferenceRepository {
  final ListeningInferenceRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ListeningInferenceRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<ListeningInferenceQuest>>> getQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return const Left(NetworkFailure('No Internet Connection'));
    }
  }
}
