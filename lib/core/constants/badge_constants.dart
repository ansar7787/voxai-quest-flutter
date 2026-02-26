import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class BadgeData {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final int? minLevel;

  const BadgeData({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    this.minLevel,
  });
}

class BadgeConstants {
  static const List<BadgeData> badges = [
    BadgeData(
      id: 'bronze_wings',
      name: 'Bronze Wings',
      icon: LucideIcons.feather,
      color: Color(0xFFCD7F32),
      minLevel: 10,
    ),
    BadgeData(
      id: 'silver_vanguard',
      name: 'Silver Vanguard',
      icon: LucideIcons.shield,
      color: Color(0xFF94A3B8),
      minLevel: 25,
    ),
    BadgeData(
      id: 'gold_legend',
      name: 'Gold Legend',
      icon: LucideIcons.sparkles,
      color: Color(0xFFFBBF24),
      minLevel: 50,
    ),
    BadgeData(
      id: 'platinum_master',
      name: 'Platinum Master',
      icon: LucideIcons.trophy,
      color: Color(0xFF22D3EE),
      minLevel: 100,
    ),
    BadgeData(
      id: 'emerald_elite',
      name: 'Emerald Elite',
      icon: LucideIcons.gem,
      color: Color(0xFF10B981),
      minLevel: 200,
    ),
    BadgeData(
      id: 'sapphire_sovereign',
      name: 'Sapphire Sovereign',
      icon: LucideIcons.crown,
      color: Color(0xFF3B82F6),
      minLevel: 300,
    ),
    BadgeData(
      id: 'ruby_royalty',
      name: 'Ruby Royalty',
      icon: LucideIcons.heart,
      color: Color(0xFFEF4444),
      minLevel: 400,
    ),
    BadgeData(
      id: 'galactic_grandmaster',
      name: 'Galactic Grandmaster',
      icon: LucideIcons.mountain,
      color: Color(0xFF8B5CF6),
      minLevel: 500,
    ),
  ];
}
