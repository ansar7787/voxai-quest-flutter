class DailyQuestManager {
  static final DateTime _epoch = DateTime(2024, 1, 1);

  /// Returns the category and level for today's quest.
  /// Returns a Map: {'category': 'reading', 'level': 3}
  static Map<String, dynamic> getDailyQuestConfig() {
    final now = DateTime.now();
    final difference = now.difference(_epoch).inDays;

    // Rotation: Reading -> Writing -> Speaking -> Grammar
    final categoryIndex = difference % 4;
    String category;
    switch (categoryIndex) {
      case 0:
        category = 'reading';
        break;
      case 1:
        category = 'writing';
        break;
      case 2:
        category = 'speaking';
        break;
      default:
        category = 'grammar';
    }

    // Level rotation: 1 to 5
    // We want it to vary, so let's use a different modulus or combo
    final level = (difference % 5) + 1;

    return {'category': category, 'level': level};
  }
}
