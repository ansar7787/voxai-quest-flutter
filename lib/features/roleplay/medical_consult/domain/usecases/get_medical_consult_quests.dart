import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/domain/entities/medical_consult_quest.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/domain/repositories/medical_consult_repository.dart';

class GetMedicalConsultQuests {
  final MedicalConsultRepository repository;

  GetMedicalConsultQuests(this.repository);

  Future<Either<Failure, List<MedicalConsultQuest>>> call(int level) async {
    return await repository.getMedicalConsultQuests(level);
  }
}
