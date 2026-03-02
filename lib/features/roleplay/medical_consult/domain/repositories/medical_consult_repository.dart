import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/medical_consult/domain/entities/medical_consult_quest.dart';

abstract class MedicalConsultRepository {
  Future<Either<Failure, List<MedicalConsultQuest>>> getMedicalConsultQuests(
    int level,
  );
}
