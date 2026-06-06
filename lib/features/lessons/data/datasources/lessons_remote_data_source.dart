import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract interface class LessonsRemoteDataSource {
  Future<void> markViewed(String wordId);
  Future<List<String>> getViewedWords();
}

@LazySingleton(as: LessonsRemoteDataSource)
class LessonsRemoteDataSourceImpl implements LessonsRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  @override
  Future<void> markViewed(String wordId) async {
    if (_userId.isEmpty) return;
    try {
      final docId = '${_userId}_${wordId}_lesson';
      await _firestore.collection('user_progress').doc(docId).set({
        'user_id': _userId,
        'poi_id': wordId,
        'type': 'lesson_viewed',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignore
    }
  }

  @override
  Future<List<String>> getViewedWords() async {
    if (_userId.isEmpty) return [];
    try {
      final snapshot = await _firestore
          .collection('user_progress')
          .where('user_id', isEqualTo: _userId)
          .where('type', isEqualTo: 'lesson_viewed')
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['poi_id'] as String)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
