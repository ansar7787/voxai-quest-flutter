import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/domain/entities/repeat_sentence_quest.dart';
import 'package:voxai_quest/features/speaking/repeat_sentence/domain/repositories/repeat_sentence_repository.dart';

class GetRepeatSentenceQuests {
  final RepeatSentenceRepository repository;

  GetRepeatSentenceQuests(this.repository);

  Future<Either<Failure, List<RepeatSentenceQuest>>> call(int level) async {
    return await repository.getRepeatSentenceQuests(level);
  }
}
