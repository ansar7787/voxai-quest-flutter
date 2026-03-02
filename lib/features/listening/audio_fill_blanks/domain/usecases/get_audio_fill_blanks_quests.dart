import 'package:dartz/dartz.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/domain/entities/audio_fill_blanks_quest.dart';
import 'package:voxai_quest/features/listening/audio_fill_blanks/domain/repositories/audio_fill_blanks_repository.dart';
import 'package:voxai_quest/core/error/failures.dart';

class GetAudioFillBlanksQuests {
  final AudioFillBlanksRepository repository;

  GetAudioFillBlanksQuests(this.repository);

  Future<Either<Failure, List<AudioFillBlanksQuest>>> call(int level) async {
    return await repository.getQuests(level);
  }
}
