import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int coins;
  final int totalExp;
  final int level;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.coins = 0,
    this.totalExp = 0,
    this.level = 1,
  });

  @override
  List<Object?> get props => [
    id,
    email,
    displayName,
    photoUrl,
    coins,
    totalExp,
    level,
  ];

  UserEntity copyWith({
    String? displayName,
    String? photoUrl,
    int? coins,
    int? totalExp,
    int? level,
  }) {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      coins: coins ?? this.coins,
      totalExp: totalExp ?? this.totalExp,
      level: level ?? this.level,
    );
  }
}
