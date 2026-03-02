import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/reading/guess_title/domain/entities/guess_title_quest.dart';

abstract class GuessTitleRepository {
  Future<Either<Failure, List<GuessTitleQuest>>> getGuessTitleQuests(int level);
}
