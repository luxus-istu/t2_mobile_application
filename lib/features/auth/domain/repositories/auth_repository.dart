import 'package:dartz/dartz.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Exception, UserEntity>> login(String email, String password);
  Future<Either<Exception, UserEntity>> register(
    String email,
    String password,
    String firstName,
    String lastName,
    String gender,
  );
  Future<Either<Exception, UserEntity>> anonymousLogin();
  Future<Either<Exception, UserEntity>> checkSession();
  Future<void> logout();
}
