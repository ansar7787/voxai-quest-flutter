import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/domain/entities/game_quest.dart';
import '../entities/listening_quest.dart';

abstract class ListeningRepository {
  Future<Either<Failure, List<ListeningQuest>>> getListeningQuests({
    required GameSubtype gameType,
    required int level,
  });
}
