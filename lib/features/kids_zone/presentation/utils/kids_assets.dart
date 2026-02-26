class KidsAssets {
  static const Map<String, List<String>> stickerMap = {
    'alphabet': ['🔠', '🅰️', '🔡', '🎓'],
    'numbers': ['🔢', '1️⃣', '💯', '🏆'],
    'colors': ['🎨', '🌈', '🖍️', '🖌️'],
    'shapes': ['📐', '🔺', '💠', '💎'],
    'animals': ['🦁', '🐯', '🐘', '🐲'],
    'fruits': ['🍎', '🍓', '🍇', '🍍'],
    'family': ['👪', '🏠', '💖', '👨‍👩‍👧‍👦'],
    'school': ['🎒', '📚', '✏️', '🏅'],
    'verbs': ['🏃', '🤸', '🏊', '⚡'],
    'routine': ['🛁', '🦷', '👕', '🌟'],
    'emotions': ['😊', '🤩', '💖', '🌈'],
    'prepositions': ['📦', '📥', '📍', '🗺️'],
    'phonics': ['🔊', '👂', '🗣️', '📢'],
    'time': ['⏰', '📅', '⏳', '🏁'],
    'opposites': ['⚖️', '🌓', '🔄', '🎯'],
    'day_night': ['🌓', '☀️', '🌙', '🌌'],
    'nature': ['🌿', '🌳', '🏔️', '🌋'],
    'home_kids': ['🏠', '🛋️', '🛌', '🏰'],
    'food_kids': ['🍕', '🍔', '🍰', '🍳'],
    'transport': ['🚀', '🚁', '🚢', '🛸'],
  };

  static const Map<String, String> accessoryMap = {
    'cape_red': '🦸',
    'shades_cool': '🕶️',
    'wand_magic': '🪄',
    'bell_gold': '🔔',
    'hat_explorer': '🤠',
    'wings_star': '🦋',
  };

  static const Map<String, String> mascotMap = {
    'owly': '🦉',
    'foxie': '🦊',
    'dino': '🦖',
  };

  static String getStickerEmoji(String stickerId) {
    // stickerId formats: "sticker_alphabet" (standard/lvl10) or "alphabet_sticker_50" etc.
    if (stickerId.contains('_sticker_')) {
      final parts = stickerId.split('_sticker_');
      final category = parts[0];
      final level = int.tryParse(parts[1]) ?? 10;
      final emojis = stickerMap[category];
      if (emojis == null) return '⭐';

      if (level >= 200) return emojis[3];
      if (level >= 100) return emojis[2];
      if (level >= 50) return emojis[1];
      return emojis[0];
    }

    final category = stickerId.replaceFirst('sticker_', '');
    return stickerMap[category]?[0] ?? '⭐';
  }
}
