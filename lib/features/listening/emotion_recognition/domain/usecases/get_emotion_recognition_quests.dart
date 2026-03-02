import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/domain/entities/emotion_recognition_quest.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/domain/repositories/emotion_recognition_repository.dart';

class GetEmotionRecognitionQuests {
  final EmotionRecognitionRepository repository;

  GetEmotionRecognitionQuests(this.repository);

  Future<Either<Failure, List<EmotionRecognitionQuest>>> call(int level) {
    return repository.getQuests(level);
  }
}
