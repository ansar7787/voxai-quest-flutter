import 'package:flutter/material.dart';

class VoxinAssets {
  // Mascots for 15+ Users (Main 81 Games)
  static const Map<String, String> mascotMap = {
    'voxin_prime': '🤖',
    'emerald_pulse': '⚡',
    'jade_sphere': '🧘',
    'phantom_green': '👻',
    'forest_owl': '🦉',
    'moss_fox': '🦊',
  };

  static const Map<String, String> mascotNames = {
    'voxin_prime': 'Voxin Elite',
    'emerald_pulse': 'Emerald Pulse',
    'jade_sphere': 'Jade Sphere',
    'phantom_green': 'Phantom Green',
    'forest_owl': 'Forest Oracle',
    'moss_fox': 'Moss Stalker',
  };

  static const Map<String, String> mascotTraits = {
    'voxin_prime': 'Supreme Intelligence Engine',
    'emerald_pulse': 'Neon Velocity Learner',
    'jade_sphere': 'Serene Language Guardian',
    'phantom_green': 'Invisible Grammar Master',
    'forest_owl': 'Ancient Algorithmic Wisdom',
    'moss_fox': 'Predatory Speech Accuracy',
  };

  // Accessories for Voxin (Purchasable with Vox Coins)
  static const Map<String, String> accessoryMap = {
    'neural_link': '🧠',
    'plasma_shield': '🛡️',
    'hotech_shades': '🕶️',
    'data_wings': '👼',
    'quantum_core': '💎',
    'sonic_mic': '🎙️',
  };

  static const Map<String, String> accessoryNames = {
    'neural_link': 'Neural Bloom',
    'plasma_shield': 'Energy Field',
    'hotech_shades': 'Cyber Optics',
    'data_wings': 'Vector Wings',
    'quantum_core': 'Emerald Matrix',
    'sonic_mic': 'Vocal Augmentation',
  };

  static const Map<String, int> accessoryPrices = {
    'neural_link': 250,
    'plasma_shield': 1200,
    'hotech_shades': 100,
    'data_wings': 3500,
    'quantum_core': 5000,
    'sonic_mic': 1800,
  };

  static const Map<String, Color> itemColors = {
    'voxin_prime': Colors.green,
    'emerald_pulse': Colors.lightGreenAccent,
    'jade_sphere': Colors.tealAccent,
    'phantom_green': Color(0xFF00FF41), // Matrix Green
    'forest_owl': Colors.greenAccent,
    'moss_fox': Color(0xFF2ECC71),
    'neural_link': Colors.greenAccent,
    'plasma_shield': Colors.lightGreen,
    'hotech_shades': Colors.green,
    'data_wings': Color(0xFF00FA9A),
    'quantum_core': Color(0xFF00FF7F),
    'sonic_mic': Colors.lightGreenAccent,
  };
}
