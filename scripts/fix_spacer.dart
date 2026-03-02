import 'dart:io';

void main() {
  final dir = Directory('lib/features/kids_zone/presentation/pages/games');
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .toList();

  // also check kids_zone_screen.dart and buddy_boutique_screen.dart, sticker_book_screen.dart
  files.addAll([
    File('lib/features/kids_zone/presentation/pages/kids_zone_screen.dart'),
    File(
      'lib/features/kids_zone/presentation/pages/buddy_boutique_screen.dart',
    ),
    File('lib/features/kids_zone/presentation/pages/sticker_book_screen.dart'),
  ]);

  for (final file in files) {
    if (!file.existsSync()) continue;
    String content = file.readAsStringSync();

    if (content.contains('const Spacer()')) {
      // Find Padding( padding: EdgeInsets.symmetric(horizontal: 24.w), child: Column(...
      // We want to turn the Column into a constrained container

      bool modified = false;

      // Replace Spacer
      if (content.contains('const Spacer(),')) {
        content = content.replaceAll(
          'const Spacer(),',
          'SizedBox(height: 40.h),',
        );
        modified = true;
      }

      // If it's a typical game screen with Padding -> child: Column
      if (content.contains('child: Column(\n                children: [')) {
        content = content.replaceAll(
          'child: Column(\n                children: [',
          'child: Container(\n                constraints: BoxConstraints(\n                  minHeight: MediaQuery.of(context).size.height - 200.h,\n                ),\n                child: Column(\n                  mainAxisAlignment: MainAxisAlignment.spaceBetween,\n                  children: [',
        );

        // Fix the closing tags. Wait, it's safer to just wrap the Column if we know the exact indentation.
        // Let's just do a simple replacement for the opening of the Column, and then find the corresponding closing.
        // Actually, wait, replacing `child: Column(` to `child: Container(\n constraints..., child: Column(` means we need to add another `),` at the end of the Column.
        // This is a bit risky with pure string replacement if the indentation varies.
      }

      if (modified) {
        // Instead of structural replacement, maybe just replacing Spacer with a large SizedBox or Expanded and adjusting list view is better?
        // Wait, the crash is because Column shrinkWraps inside a SingleChildScrollView, meaning we cannot use Expanded or Spacer. Spacer is essentially Expanded(child: SizedBox.shrink()).
        // If we just replace const Spacer() with SizedBox(height: 40.h), the layout won't crash and might look okay! Let's check.
      }
    }
  }
}
