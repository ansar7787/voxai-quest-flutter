import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/domain/entities/pronunciation_focus_quest.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/domain/repositories/pronunciation_focus_repository.dart';

class GetPronunciationFocusQuests {
  final PronunciationFocusRepository repository;

  GetPronunciationFocusQuests(this.repository);

  Future<Either<Failure, List<PronunciationFocusQuest>>> call(int level) async {
    return await repository.getPronunciationFocusQuests(level);
  }
}
