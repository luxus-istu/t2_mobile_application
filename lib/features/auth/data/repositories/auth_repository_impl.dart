import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:t2_mobile_application/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:t2_mobile_application/features/auth/domain/repositories/auth_repository.dart';

@LazySingleton(as: AuthRepository)
final class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;
  final AuthRemoteDataSource remoteDataSource;

  const AuthRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<Either<Exception, UserEntity>> login(
    String phone,
    String password,
  ) async {
    try {
      final userModel = await remoteDataSource.login(phone, password);
      await localDataSource.register(phone, password, userModel.firstName, userModel.lastName, userModel.gender);
      return Right(userModel.toEntity());
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
      final userModel = await remoteDataSource.register(
        phone,
        password,
        firstName,
        lastName,
        gender,
      );
      await localDataSource.register(phone, password, firstName, lastName, gender);
      return Right(userModel.toEntity());
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, UserEntity>> checkSession() async {
    try {
      var userModel = await remoteDataSource.checkSession();
      if (userModel != null) {
        return Right(userModel.toEntity());
      }
      
      final localSession = await localDataSource.checkSession();
      return localSession.fold((l) => Left(l), (r) {
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

  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.logout();
  }
}
