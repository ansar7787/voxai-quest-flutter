import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voxai_quest/features/roleplay/conflict_resolver/data/models/conflict_resolver_quest_model.dart';

abstract class ConflictResolverRemoteDataSource {
  Future<List<ConflictResolverQuestModel>> getConflictResolverQuests(int level);
}

class ConflictResolverRemoteDataSourceImpl
    implements ConflictResolverRemoteDataSource {
  final FirebaseFirestore firestore;

  ConflictResolverRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<ConflictResolverQuestModel>> getConflictResolverQuests(
    int level,
  ) async {
    final snapshot = await firestore
        .collection('curriculum')
        .doc('roleplay')
        .collection('conflictResolver')
        .where('difficulty', isEqualTo: level)
        .get();

    return snapshot.docs
        .map(
          (doc) =>
              ConflictResolverQuestModel.fromJson(doc.data()..['id'] = doc.id),
        )
        .toList();
  }
}
