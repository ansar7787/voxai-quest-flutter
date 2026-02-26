import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/core/usecases/usecase.dart';
import 'package:voxai_quest/features/writing/domain/entities/writing_quest.dart';
import 'package:voxai_quest/features/writing/domain/repositories/writing_repository.dart';
import 'package:voxai_quest/features/speaking/domain/usecases/get_speaking_quest.dart'; // For QuestParams

class GetWritingQuest implements UseCase<List<WritingQuest>, QuestParams> {
  final WritingRepository repository;

  GetWritingQuest(this.repository);

  @override
  Future<Either<Failure, List<WritingQuest>>> call(QuestParams params) async {
    return await repository.getWritingQuest(
      gameType: params.gameType,
      level: params.level,
    );
  }
}
