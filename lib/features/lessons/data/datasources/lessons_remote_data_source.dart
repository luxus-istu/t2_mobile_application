import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t2_mobile_application/core/config/supabase_config.dart';

abstract interface class LessonsRemoteDataSource {
  Future<void> markViewed(String wordId);
  Future<List<String>> getViewedWords();
}

@LazySingleton(as: LessonsRemoteDataSource)
class LessonsRemoteDataSourceImpl implements LessonsRemoteDataSource {
  final SupabaseClient _client = SupabaseConfig.client;
  
  String get _userId => _client.auth.currentUser?.id ?? '';

  @override
  Future<void> markViewed(String wordId) async {
    if (_userId.isEmpty) return;
    try {
      await _client.from('user_progress').upsert({
        'user_id': _userId,
        'poi_id': wordId,
        'type': 'lesson_viewed',
      });
    } catch (e) {
      // Ignore
    }
  }

  @override
  Future<List<String>> getViewedWords() async {
    if (_userId.isEmpty) return [];
    try {
      final response = await _client
          .from('user_progress')
          .select('poi_id')
          .eq('user_id', _userId)
          .eq('type', 'lesson_viewed');
          
      return (response as List).map((e) => e['poi_id'] as String).toList();
    } catch (e) {
      return [];
    }
  }
}
