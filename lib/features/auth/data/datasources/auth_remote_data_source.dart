import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:t2_mobile_application/core/config/supabase_config.dart';
import 'package:t2_mobile_application/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login(String phone, String password);
  Future<UserModel> register(
    String phone,
    String password,
    String firstName,
    String lastName,
    String gender,
  );
  Future<UserModel?> checkSession();
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _client = SupabaseConfig.client;

  String _emailFromPhone(String phone) => '${phone.replaceAll('+', '')}@example.com';

  @override
  Future<UserModel> login(String phone, String password) async {
    final response = await _client.auth.signInWithPassword(
      email: _emailFromPhone(phone),
      password: password,
    );
    final user = response.user;
    if (user == null) throw Exception('Login failed');
    
    return UserModel(
      phone: phone,
      password: password,
      firstName: user.userMetadata?['first_name'] ?? '',
      lastName: user.userMetadata?['last_name'] ?? '',
      gender: user.userMetadata?['gender'] ?? '',
    );
  }

  @override
  Future<UserModel> register(
    String phone,
    String password,
    String firstName,
    String lastName,
    String gender,
  ) async {
    final response = await _client.auth.signUp(
      email: _emailFromPhone(phone),
      password: password,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'phone': phone,
      },
    );
    
    final user = response.user;
    if (user == null) throw Exception('Registration failed');
    
    return UserModel(
      phone: phone,
      password: password,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
    );
  }

  @override
  Future<UserModel?> checkSession() async {
    final session = _client.auth.currentSession;
    if (session == null) return null;
    
    final user = session.user;
    return UserModel(
      phone: user.userMetadata?['phone'] ?? '',
      password: '',
      firstName: user.userMetadata?['first_name'] ?? '',
      lastName: user.userMetadata?['last_name'] ?? '',
      gender: user.userMetadata?['gender'] ?? '',
    );
  }

  @override
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
