import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract interface class GamesRemoteDataSource {
  Future<void> saveResult({required String gameKey, required bool isCorrect});
  Future<List<Map<String, dynamic>>> getResults();
}

@LazySingleton(as: GamesRemoteDataSource)
class GamesRemoteDataSourceImpl implements GamesRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  @override
  Future<void> saveResult({
    required String gameKey,
    required bool isCorrect,
  }) async {
    if (_userId.isEmpty) return;
    try {
      await _firestore.collection('user_progress').add({
        'user_id': _userId,
        'poi_id': gameKey,
        'type': isCorrect ? 'game_correct' : 'game_incorrect',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignore
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getResults() async {
    if (_userId.isEmpty) return [];
    try {
      final snapshot = await _firestore
          .collection('user_progress')
          .where('user_id', isEqualTo: _userId)
          .where('type', whereIn: ['game_correct', 'game_incorrect'])
          .get();

      return snapshot.docs
          .map(
            (doc) => {
              'poi_id': doc.data()['poi_id'],
              'type': doc.data()['type'],
            },
          )
          .toList();
    } catch (e) {
      return [];
    }
  }
}
