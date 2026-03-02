import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/guess_title/domain/entities/guess_title_quest.dart';
import 'package:voxai_quest/features/reading/guess_title/domain/repositories/guess_title_repository.dart';

class GetGuessTitleQuests {
  final GuessTitleRepository repository;

  GetGuessTitleQuests(this.repository);

  Future<Either<Failure, List<GuessTitleQuest>>> call(int level) async {
    return await repository.getGuessTitleQuests(level);
  }
}
