import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/auth/data/models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<UserModel> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gender,
  );
  Future<UserModel> anonymousLogin();
  Future<UserModel?> checkSession();
  Future<void> logout();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = response.user;
    if (user == null) throw Exception('Login failed');

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data() ?? {};

    return UserModel(
      email: email,
      password: password,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      gender: data['gender'] ?? '',
    );
  }

  @override
  Future<UserModel> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gender,
  ) async {
    final response = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = response.user;
    if (user == null) throw Exception('Registration failed');

    await _firestore.collection('users').doc(user.uid).set({
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'email': email,
    });

    return UserModel(
      email: email,
      password: password,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
    );
  }

  @override
  Future<UserModel> anonymousLogin() async {
    final response = await _auth.signInAnonymously();
    final user = response.user;
    if (user == null) throw Exception('Anonymous login failed');

    return UserModel(
      email: 'guest_${user.uid}@example.com',
      password: '',
      firstName: 'Гость',
      lastName: '',
      gender: 'none',
    );
  }

  @override
  Future<UserModel?> checkSession() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data() ?? {};

    return UserModel(
      email: data['email'] ?? user.email ?? 'guest_${user.uid}@example.com',
      password: '',
      firstName: data['first_name'] ?? 'Гость',
      lastName: data['last_name'] ?? '',
      gender: data['gender'] ?? 'none',
    );
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }
}
