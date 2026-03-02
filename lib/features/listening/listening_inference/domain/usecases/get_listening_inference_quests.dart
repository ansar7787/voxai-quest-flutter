import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/listening_inference/domain/entities/listening_inference_quest.dart';
import 'package:voxai_quest/features/listening/listening_inference/domain/repositories/listening_inference_repository.dart';

class GetListeningInferenceQuests {
  final ListeningInferenceRepository repository;

  GetListeningInferenceQuests(this.repository);

  Future<Either<Failure, List<ListeningInferenceQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
