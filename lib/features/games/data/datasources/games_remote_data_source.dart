import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t2_mobile_application/core/config/supabase_config.dart';

abstract interface class GamesRemoteDataSource {
  Future<void> saveResult({required String gameKey, required bool isCorrect});
  Future<List<Map<String, dynamic>>> getResults();
}

@LazySingleton(as: GamesRemoteDataSource)
class GamesRemoteDataSourceImpl implements GamesRemoteDataSource {
  final SupabaseClient _client = SupabaseConfig.client;
  
  String get _userId => _client.auth.currentUser?.id ?? '';

  @override
  Future<void> saveResult({required String gameKey, required bool isCorrect}) async {
    if (_userId.isEmpty) return;
    try {
      await _client.from('user_progress').insert({
        'user_id': _userId,
        'poi_id': gameKey,
        'type': isCorrect ? 'game_correct' : 'game_incorrect',
      });
    } catch (e) {
      // Ignore
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getResults() async {
    if (_userId.isEmpty) return [];
    try {
      final response = await _client
          .from('user_progress')
          .select('poi_id, type')
          .eq('user_id', _userId)
          .like('type', 'game_%');
          
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      return [];
    }
  }
}
