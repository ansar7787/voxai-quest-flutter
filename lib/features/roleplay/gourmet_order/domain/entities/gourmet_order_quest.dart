import 'package:voxai_quest/core/domain/entities/game_quest.dart';

class GourmetOrderQuest extends GameQuest {
  final String? customerName;
  final String? orderDetails;
  final List<String>? ingredients;
  final String? specialRequest;
  final String? response;

  const GourmetOrderQuest({
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
    this.customerName,
    this.orderDetails,
    this.ingredients,
    this.specialRequest,
    this.response,
  });

  @override
  List<Object?> get props => [
        ...super.props,
        customerName,
        orderDetails,
        ingredients,
        specialRequest,
        response,
      ];
}
