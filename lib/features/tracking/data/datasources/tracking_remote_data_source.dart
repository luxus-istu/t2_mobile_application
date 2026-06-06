import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';

abstract interface class TrackingRemoteDataSource {
  Future<void> saveVisitedPoi(String id);
  Future<List<String>> getVisitedPois();
}

@LazySingleton(as: TrackingRemoteDataSource)
class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String get _userId => _auth.currentUser?.uid ?? '';

  @override
  Future<void> saveVisitedPoi(String id) async {
    if (_userId.isEmpty) return;
    try {
      final docId = '${_userId}_${id}_visited';
      await _firestore.collection('user_progress').doc(docId).set({
        'user_id': _userId,
        'poi_id': id,
        'type': 'visited_poi',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Ignore errors if offline or table doesn't exist yet
    }
  }

  @override
  Future<List<String>> getVisitedPois() async {
    if (_userId.isEmpty) return [];
    try {
      final snapshot = await _firestore
          .collection('user_progress')
          .where('user_id', isEqualTo: _userId)
          .where('type', isEqualTo: 'visited_poi')
          .get();

      return snapshot.docs
          .map((doc) => doc.data()['poi_id'] as String)
          .toList();
    } catch (e) {
      return [];
    }
  }
}
