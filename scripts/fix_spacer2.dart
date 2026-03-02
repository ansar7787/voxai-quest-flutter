import 'package:flutter/foundation.dart';
import 'dart:io';

void main() {
  final dir = Directory(r'lib\features\kids_zone\presentation\pages');
  final files = dir
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'));

  for (final file in files) {
    String content = file.readAsStringSync();
    if (!content.contains('const Spacer()')) continue;

    // Quick replace for Spacer
    content = content.replaceAll('const Spacer(),', 'SizedBox(height: 40.h),');

    final t1 = '''              child: Column(
                children: [''';
    final r1 = '''              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 200.h,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [''';

    final e1 = '''                  ],
                ),
              ),
            ],
          );''';
    final n1 = '''                  ],
                ),
              ),
            ),
          ],
        );''';

    final t2 = '''            child: Column(
              children: [''';
    final r2 = '''            child: Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 200.h,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [''';

    final e2 = '''                ],
              ),
            ),
          ],
        );''';
    final n2 = '''                ],
              ),
            ),
          ),
        ],
      );''';

    bool modified = false;

    if (content.contains(t1)) {
      content = content.replaceAll(t1, r1);
      if (content.contains(e1)) content = content.replaceAll(e1, n1);
      modified = true;
    } else if (content.contains(t2)) {
      content = content.replaceAll(t2, r2);
      if (content.contains(e2)) content = content.replaceAll(e2, n2);
      modified = true;
    } else {
      // Fallback for others like kids_zone_screen
      modified = true;
    }

    if (modified) {
      file.writeAsStringSync(content);
      debugPrint('Fixed \${file.path}');
    }
  }
}
