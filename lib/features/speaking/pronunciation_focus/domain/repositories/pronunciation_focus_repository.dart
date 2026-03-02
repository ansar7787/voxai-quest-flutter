import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/pronunciation_focus/domain/entities/pronunciation_focus_quest.dart';

abstract class PronunciationFocusRepository {
  Future<Either<Failure, List<PronunciationFocusQuest>>>
  getPronunciationFocusQuests(int level);
}
