import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/domain/entities/sentence_correction_quest.dart';
import 'package:voxai_quest/features/grammar/sentence_correction/domain/repositories/sentence_correction_repository.dart';

class GetSentenceCorrectionQuests {
  final SentenceCorrectionRepository repository;

  GetSentenceCorrectionQuests(this.repository);

  Future<Either<Failure, List<SentenceCorrectionQuest>>> call(int level) async {
    return await repository.getSentenceCorrectionQuests(level);
  }
}
