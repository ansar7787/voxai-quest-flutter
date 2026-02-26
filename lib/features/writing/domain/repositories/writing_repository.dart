import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/domain/entities/game_quest.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';

abstract class WritingRepository {
  Future<Either<Failure, List<WritingQuest>>> getWritingQuest({
    required GameSubtype gameType,
    required int level,
  });
}
