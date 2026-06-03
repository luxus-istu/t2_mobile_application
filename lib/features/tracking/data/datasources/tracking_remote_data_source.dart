import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t2_mobile_application/core/config/supabase_config.dart';

abstract interface class TrackingRemoteDataSource {
  Future<void> saveVisitedPoi(String id);
  Future<List<String>> getVisitedPois();
}

@LazySingleton(as: TrackingRemoteDataSource)
class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  final SupabaseClient _client = SupabaseConfig.client;
  
  String get _userId => _client.auth.currentUser?.id ?? '';

  @override
  Future<void> saveVisitedPoi(String id) async {
    if (_userId.isEmpty) return;
    try {
      await _client.from('user_progress').upsert({
        'user_id': _userId,
        'poi_id': id,
        'type': 'visited_poi',
      });
    } catch (e) {
      // Ignore errors if offline or table doesn't exist yet
    }
  }

  @override
  Future<List<String>> getVisitedPois() async {
    if (_userId.isEmpty) return [];
    try {
      final response = await _client
          .from('user_progress')
          .select('poi_id')
          .eq('user_id', _userId)
          .eq('type', 'visited_poi');
      
      return (response as List).map((e) => e['poi_id'] as String).toList();
    } catch (e) {
      return [];
    }
  }
}
