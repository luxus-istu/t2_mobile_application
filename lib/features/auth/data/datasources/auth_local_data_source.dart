import 'package:dartz/dartz.dart';
import 'package:t2_mobile_application/features/auth/data/models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<Either<Exception, UserModel>> login(String email, String password);
  Future<Either<Exception, UserModel>> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gender,
  );
  Future<Either<Exception, UserModel?>> checkSession();
  Future<void> logout();
}
