import 'package:flutter/foundation.dart';
import 'dart:io';

void main() {
  final blocs = {
    'Reading': 'lib/features/reading/presentation/bloc/reading_bloc.dart',
    'Writing': 'lib/features/writing/presentation/bloc/writing_bloc.dart',
    'Listening': 'lib/features/listening/presentation/bloc/listening_bloc.dart',
    'Grammar': 'lib/features/grammar/presentation/bloc/grammar_bloc.dart',
    'Accent': 'lib/features/accent/presentation/bloc/accent_bloc.dart',
    'Roleplay': 'lib/features/roleplay/presentation/bloc/roleplay_bloc.dart',
    'Vocabulary':
        'lib/features/vocabulary/presentation/bloc/vocabulary_bloc.dart',
  };

  for (final entry in blocs.entries) {
    final name = entry.key;
    final path = entry.value;
    final file = File(path);
    if (!file.existsSync()) continue;

    String content = file.readAsStringSync();

    // Check if it's already using QuestParams
    if (!content.contains('QuestParams')) {
      // We need to add QuestParams import if not present
      if (!content.contains(
        'import \'../../../../features/speaking/domain/usecases/get_speaking_quest.dart\';',
      )) {
        content = content.replaceFirst(
          'import \'package:flutter_bloc/flutter_bloc.dart\';',
          'import \'package:flutter_bloc/flutter_bloc.dart\';\nimport \'../../../../features/speaking/domain/usecases/get_speaking_quest.dart\';',
        );
      }
    }

    final oldPattern =
        '''
        final List<${name}Quest> quests = [];

        try {
          final result = await getQuest!(event.gameType, event.level);
          if (result != null && result is List<${name}Quest>) {
            quests.addAll(result);
          }
        } catch (e) {
          try {
            final result = await getQuest!(event.gameType);
            if (result != null && result is List<${name}Quest>) {
              quests.addAll(result);
            }
          } catch (_) {}
        }

        if (quests.isEmpty) {
          emit(${name}Error("We couldn\\'t find any quests for this level yet."));
        } else {
''';

    final oldPattern2 =
        '''
      final List<${name}Quest> quests = [];
      try {
        final result = await getQuest!(event.gameType, event.level);
        if (result != null && result is List<${name}Quest>) {
          quests.addAll(result);
        }
      } catch (e) {
        try {
          final result = await getQuest!(event.gameType);
          if (result != null && result is List<${name}Quest>) {
            quests.addAll(result);
          }
        } catch (_) {}
      }

      if (quests.isEmpty) {
        emit(${name}Error("We couldn\\'t find any quests for this level yet."));
        return;
      }

      if (quests.isEmpty) {
        emit(${name}Error("Check back later for new quests!"));
      } else {
''';

    final replacePattern =
        '''
        final GameSubtype subtype = event.gameType is GameSubtype
            ? event.gameType
            : GameSubtype.values.firstWhere(
                (s) => s.name == event.gameType.toString() || s.toString() == event.gameType.toString(),
                orElse: () => GameSubtype.values.firstWhere((s) => s.name == event.gameType.toString().split('.').last, orElse: () => GameSubtype.values.first),
              );

        final result = await getQuest!(QuestParams(gameType: subtype, level: event.level));

        result.fold(
          (failure) => emit(${name}Error(failure.message)),
          (quests) {
            if (quests.isEmpty) {
              emit(${name}Error("We couldn\\'t find any quests for this level yet."));
            } else {
''';

    // Try replace oldPattern (ReadingBloc style)
    if (content.contains(oldPattern)) {
      content = content.replaceAll(oldPattern, replacePattern);
      file.writeAsStringSync(content);
      debugPrint('Fixed \$name');
    }
    // Try replace oldPattern2 (WritingBloc style)
    else if (content.contains(oldPattern2)) {
      content = content.replaceAll(oldPattern2, replacePattern);
      file.writeAsStringSync(content);
      debugPrint('Fixed \$name (style 2)');
    } else {
      debugPrint('Could not find pattern for \$name');
    }
  }
}
