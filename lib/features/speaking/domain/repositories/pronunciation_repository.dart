import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/domain/entities/pronunciation_quest.dart';

abstract class PronunciationRepository {
  Future<Either<Failure, PronunciationQuest>> getPronunciationQuest(
    int difficulty,
  );
}
