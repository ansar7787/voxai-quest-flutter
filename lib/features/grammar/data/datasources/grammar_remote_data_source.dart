import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/core/error/exceptions.dart';
import 'package:voxai_quest/features/grammar/data/models/grammar_quest_model.dart';

abstract class GrammarRemoteDataSource {
  Future<GrammarQuestModel> getGrammarQuest(int level);
}

class GrammarRemoteDataSourceImpl implements GrammarRemoteDataSource {
  final FirebaseFirestore firestore;

  GrammarRemoteDataSourceImpl(this.firestore);

  @override
  Future<GrammarQuestModel> getGrammarQuest(int level) async {
    try {
      final docId = 'grammar_$level';
      var doc = await firestore.collection('grammar_quests').doc(docId).get();

      if (!doc.exists) {
        final snapshot = await firestore.collection('grammar_quests').get();
        if (snapshot.docs.isNotEmpty) {
          final randomIndex = (level - 1) % snapshot.docs.length;
          doc = snapshot.docs[randomIndex];
        }
      }

      if (doc.exists) {
        final data = doc.data()!;
        data['id'] = doc.id;
        data['difficulty'] = level;
        return GrammarQuestModel.fromJson(data);
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
