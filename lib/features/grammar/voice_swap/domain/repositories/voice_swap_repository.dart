import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/voice_swap/domain/entities/voice_swap_quest.dart';

abstract class VoiceSwapRepository {
  Future<Either<Failure, List<VoiceSwapQuest>>> getVoiceSwapQuests(int level);
}
