import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:t2_mobile_application/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  const AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Exception, UserEntity>> login(
    String phone,
    String password,
  ) async {
    try {
      final userModel = await localDataSource.login(phone, password);
      return userModel.fold((l) => Left(l), (r) => Right(r.toEntity()));
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, UserEntity>> register(
    String phone,
    String password,
    String firstName,
    String lastName,
    String gender,
  ) async {
    try {
      final userModel = await localDataSource.register(
        phone,
        password,
        firstName,
        lastName,
        gender,
      );
      return userModel.fold((l) => Left(l), (r) => Right(r.toEntity()));
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, UserEntity>> checkSession() async {
    try {
      final userModel = await localDataSource.checkSession();
      return userModel.fold((l) => Left(l), (r) {
        if (r == null) {
          return Left(Exception('No active session'));
        }
        return Right(r.toEntity());
      });
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await localDataSource.logout();
  }
}
