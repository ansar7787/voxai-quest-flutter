import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/branching_dialogue/data/models/branching_dialogue_quest_model.dart';

abstract class BranchingDialogueRemoteDataSource {
  Future<List<BranchingDialogueQuestModel>> getBranchingDialogueQuests(
    int level,
  );
}

class BranchingDialogueRemoteDataSourceImpl
    implements BranchingDialogueRemoteDataSource {
  final FirebaseFirestore firestore;

  BranchingDialogueRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<BranchingDialogueQuestModel>> getBranchingDialogueQuests(
    int level,
  ) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('branchingDialogue')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              BranchingDialogueQuestModel.fromJson(doc.data()..['id'] = doc.id),
        )
        .toList();
  }
}
