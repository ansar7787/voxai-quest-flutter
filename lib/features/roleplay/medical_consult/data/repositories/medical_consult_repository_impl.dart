import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/domain/entities/medical_consult_quest.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/domain/repositories/medical_consult_repository.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/data/datasources/medical_consult_remote_data_source.dart';

class MedicalConsultRepositoryImpl implements MedicalConsultRepository {
  final MedicalConsultRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MedicalConsultRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<MedicalConsultQuest>>> getMedicalConsultQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getMedicalConsultQuests(level);
        return Right(remoteQuests);
      } on ServerException {
        return Left(ServerFailure('Server error occurred'));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

