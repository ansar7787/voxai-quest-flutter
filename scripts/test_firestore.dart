import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final db = FirebaseFirestore.instance;

  // Let's check "repeatSentence" level 1
  debugPrint('Fetching repeatSentence level 1...');
  try {
    final doc = await db
        .collection('quests')
        .doc('repeatSentence')
        .collection('levels')
        .doc('1')
        .get();
    if (doc.exists) {
      debugPrint('Doc exists!');
      debugPrint('Data: ${doc.data()}');
    } else {
      debugPrint('Doc DOES NOT EXIST');

      // Let's list what's in 'quests/repeatSentence/levels'
      final snapshot = await db
          .collection('quests')
          .doc('repeatSentence')
          .collection('levels')
          .limit(5)
          .get();
      debugPrint('Found ${snapshot.docs.length} docs in levels collection.');
      for (var d in snapshot.docs) {
        debugPrint(' - ${d.id}');
      }
    }
  } catch (e) {
    debugPrint('Error: $e');
  }
}
