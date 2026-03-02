import 'package:dartz/dartz.dart';
import 'package:voxai_quest/core/error/failures.dart';
import 'package:voxai_quest/features/grammar/voice_swap/domain/entities/voice_swap_quest.dart';
import 'package:voxai_quest/features/grammar/voice_swap/domain/repositories/voice_swap_repository.dart';

class GetVoiceSwapQuests {
  final VoiceSwapRepository repository;

  GetVoiceSwapQuests(this.repository);

  Future<Either<Failure, List<VoiceSwapQuest>>> call(int level) async {
    return await repository.getVoiceSwapQuests(level);
  }
}
