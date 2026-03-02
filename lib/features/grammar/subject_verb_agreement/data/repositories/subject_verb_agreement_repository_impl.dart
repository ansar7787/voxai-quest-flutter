import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/network/network_info.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/data/datasources/subject_verb_agreement_remote_data_source.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/domain/entities/subject_verb_agreement_quest.dart';
import 'package:voxai_quest/features/grammar/subject_verb_agreement/domain/repositories/subject_verb_agreement_repository.dart';

class SubjectVerbAgreementRepositoryImpl implements SubjectVerbAgreementRepository {
  final SubjectVerbAgreementRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  SubjectVerbAgreementRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SubjectVerbAgreementQuest>>> getSubjectVerbAgreementQuests(int level) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteQuests = await remoteDataSource.getSubjectVerbAgreementQuests(level);
        return Right(remoteQuests);
      } catch (e) {
        return Left(ServerFailure(e.toString()));
      }
    } else {
      return Left(NetworkFailure('No Internet Connection'));
    }
  }
}

