import 'package:dartz/dartz.dart';
import 'package:t2_mobile_application/features/auth/data/models/user_model.dart';

abstract interface class AuthLocalDataSource {
  Future<Either<Exception, UserModel>> loginOrRegister(
    String phone,
    String password,
  );
  Future<Either<Exception, UserModel?>> checkSession();
  Future<void> logout();
}
