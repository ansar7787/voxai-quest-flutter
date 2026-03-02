import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/word_reorder/domain/entities/word_reorder_quest.dart';

abstract class WordReorderRepository {
  Future<Either<Failure, List<WordReorderQuest>>> getWordReorderQuests(
    int level,
  );
}
