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
    super.isPremium,
    super.premiumExpiryDate,
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
      isPremium: map['isPremium'] ?? false,
      premiumExpiryDate: map['premiumExpiryDate'] != null
          ? (map['premiumExpiryDate'] as dynamic).toDate()
          : null,
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
      'isPremium': isPremium,
      'premiumExpiryDate': premiumExpiryDate != null
          ? Timestamp.fromDate(premiumExpiryDate!)
          : null,
    };
  }
}
