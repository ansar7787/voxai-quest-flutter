import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.coins,
    super.totalExp,
    super.level,
    super.isAdmin,
    super.currentStreak,
    super.lastLoginDate,
    super.isEmailVerified,
    super.isPremium,
    super.premiumExpiryDate,
    super.categoryStats,
    super.badges,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      coins: map['coins'] ?? 0,
      totalExp: map['totalExp'] ?? 0,
      level: map['level'] ?? 1,
      isAdmin: map['isAdmin'] ?? false,
      currentStreak: map['currentStreak'] ?? 0,
      lastLoginDate: map['lastLoginDate'] != null
          ? (map['lastLoginDate'] as dynamic).toDate()
          : null,
      isEmailVerified: map['isEmailVerified'] ?? false,
      isPremium: map['isPremium'] ?? false,
      premiumExpiryDate: map['premiumExpiryDate'] != null
          ? (map['premiumExpiryDate'] as Timestamp).toDate()
          : null,
      categoryStats: map['categoryStats'] != null
          ? Map<String, int>.from(map['categoryStats'])
          : {},
      badges: map['badges'] != null ? List<String>.from(map['badges']) : [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'coins': coins,
      'totalExp': totalExp,
      'level': level,
      'isAdmin': isAdmin,
      'currentStreak': currentStreak,
      'lastLoginDate': lastLoginDate != null
          ? Timestamp.fromDate(lastLoginDate!)
          : null,
      'isEmailVerified': isEmailVerified,
      'isPremium': isPremium,
      'premiumExpiryDate': premiumExpiryDate != null
          ? Timestamp.fromDate(premiumExpiryDate!)
          : null,
      'categoryStats': categoryStats,
      'badges': badges,
    };
  }
}
