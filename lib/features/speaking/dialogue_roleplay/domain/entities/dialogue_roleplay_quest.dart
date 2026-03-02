import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class DialogueRoleplayQuest extends GameQuest {
  final String? lastLine;
  final String? sampleAnswer;
  final String? topic;
  final List<DialogueTurn>? turns;

  const DialogueRoleplayQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType = InteractionType.speech,
    this.lastLine,
    this.sampleAnswer,
    this.topic,
    this.turns,
  });

  @override
  List<Object?> get props => [...super.props, lastLine, sampleAnswer, topic];
}

class DialogueTurn {
  final String speaker;
  final String text;
  final bool isUser;
  final String? translation;

  const DialogueTurn({
    required this.speaker,
    required this.text,
    required this.isUser,
    this.translation,
  });

  factory DialogueTurn.fromJson(Map<String, dynamic> json) {
    return DialogueTurn(
      speaker: json['speaker'] as String? ?? 'AI',
      text: json['text'] as String? ?? '',
      isUser: json['isUser'] as bool? ?? false,
      translation: json['translation'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker,
      'text': text,
      'isUser': isUser,
      'translation': translation,
    };
  }
}
