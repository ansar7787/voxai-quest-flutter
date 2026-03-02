import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class TravelDeskQuest extends GameQuest {
  final String? destination;
  final String? travelerName;
  final String? travelQuery;
  final List<String>?
  optionsList; // Renamed to avoid name clash with GameQuest.options
  final String? response;

  const TravelDeskQuest({
    required super.id,
    super.type,
    required super.instruction,
    required super.difficulty,
    super.subtype,
    super.xpReward,
    super.coinReward,
    super.livesAllowed,
    super.interactionType,
    super.options,
    super.correctAnswerIndex,
    this.destination,
    this.travelerName,
    this.travelQuery,
    this.optionsList,
    this.response,
  });

  @override
  List<Object?> get props => [
    ...super.props,
    destination,
    travelerName,
    travelQuery,
    optionsList,
    response,
  ];
}
