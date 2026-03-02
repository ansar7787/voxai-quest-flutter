import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/roleplay/gourmet_order/domain/entities/gourmet_order_quest.dart';

abstract class GourmetOrderRepository {
  Future<Either<Failure, List<GourmetOrderQuest>>> getGourmetOrderQuests(int level);
}
