import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/word_reorder/domain/entities/word_reorder_quest.dart';
import 'package:voxai_quest/features/grammar/word_reorder/domain/repositories/word_reorder_repository.dart';

class GetWordReorderQuests {
  final WordReorderRepository repository;

  GetWordReorderQuests(this.repository);

  Future<Either<Failure, List<WordReorderQuest>>> call(int level) async {
    return await repository.getWordReorderQuests(level);
  }
}
