import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> init() async {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL'] ?? 'https://your-project.supabase.co',
      anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? 'your-anon-key',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
