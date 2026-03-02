import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/domain/entities/gourmet_order_quest.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/domain/repositories/gourmet_order_repository.dart';

class GetGourmetOrderQuests {
  final GourmetOrderRepository repository;

  GetGourmetOrderQuests(this.repository);

  Future<Either<Failure, List<GourmetOrderQuest>>> call(int level) async {
    return await repository.getGourmetOrderQuests(level);
  }
}
