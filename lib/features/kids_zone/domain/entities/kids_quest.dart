import 'package:equatable/equatable.dart';

class KidsQuest extends Equatable {
  final String id;
  final String gameType; // e.g., 'alphabet', 'colors'
  final int level;
  final String instruction;
  final String? question;
  final String? correctAnswer;
  final List<String>? options;
  final String? imageUrl;
  final String? audioUrl;
  final Map<String, dynamic>? metadata;

  const KidsQuest({
    required this.id,
    required this.gameType,
    required this.level,
    required this.instruction,
    this.question,
    this.correctAnswer,
    this.options,
    this.imageUrl,
    this.audioUrl,
    this.metadata,
  });

  @override
  List<Object?> get props => [
    id,
    gameType,
    level,
    instruction,
    question,
    correctAnswer,
    options,
    imageUrl,
    audioUrl,
    metadata,
  ];
}
