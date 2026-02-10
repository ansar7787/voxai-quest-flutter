import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final int coins;
  final int totalExp;
  final int level;
  final bool isAdmin;
  final int currentStreak;
  final DateTime? lastLoginDate;
  final bool isPremium;
  final DateTime? premiumExpiryDate;

  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.coins = 0,
    this.totalExp = 0,
    this.level = 1,
    this.isAdmin = false,
    this.currentStreak = 0,
    this.lastLoginDate,
    this.isPremium = false,
    this.premiumExpiryDate,
    this.categoryStats = const {},
    this.badges = const [],
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
    isAdmin,
    currentStreak,
    lastLoginDate,
    isPremium,
    premiumExpiryDate,
    categoryStats,
    badges,
  ];

  final Map<String, int> categoryStats;
  final List<String> badges;

  UserEntity copyWith({
    String? displayName,
    String? photoUrl,
    int? coins,
    int? totalExp,
    int? level,
    bool? isAdmin,
    int? currentStreak,
    DateTime? lastLoginDate,
    bool? isPremium,
    DateTime? premiumExpiryDate,
    Map<String, int>? categoryStats,
    List<String>? badges,
  }) {
    return UserEntity(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      coins: coins ?? this.coins,
      totalExp: totalExp ?? this.totalExp,
      level: level ?? this.level,
      isAdmin: isAdmin ?? this.isAdmin,
      currentStreak: currentStreak ?? this.currentStreak,
      lastLoginDate: lastLoginDate ?? this.lastLoginDate,
      isPremium: isPremium ?? this.isPremium,
      premiumExpiryDate: premiumExpiryDate ?? this.premiumExpiryDate,
      categoryStats: categoryStats ?? this.categoryStats,
      badges: badges ?? this.badges,
    );
  }
}
