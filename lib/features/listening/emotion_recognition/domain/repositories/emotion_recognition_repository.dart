import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/listening/emotion_recognition/domain/entities/emotion_recognition_quest.dart';

abstract class EmotionRecognitionRepository {
  Future<Either<Failure, List<EmotionRecognitionQuest>>> getQuests(int level);
}
