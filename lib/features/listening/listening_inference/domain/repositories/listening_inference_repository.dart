import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/listening_inference/domain/entities/listening_inference_quest.dart';

abstract class ListeningInferenceRepository {
  Future<Either<Failure, List<ListeningInferenceQuest>>> getQuests(int level);
}
