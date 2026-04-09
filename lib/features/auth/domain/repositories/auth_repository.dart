import 'package:dartz/dartz.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<Exception, UserEntity>> login(String phone, String password);
  Future<Either<Exception, UserEntity>> register(
    String phone,
    String password,
    String firstName,
    String lastName,
    String gender,
  );
  Future<Either<Exception, UserEntity>> checkSession();
  Future<void> logout();
}
