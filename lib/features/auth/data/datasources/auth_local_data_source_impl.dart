import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:t2_mobile_application/features/auth/data/models/user_model.dart';

@LazySingleton(as: AuthLocalDataSource)
final class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String sessionKey = 'active_user_phone';

  final Box<UserModel> usersBox;
  final FlutterSecureStorage storage;

  const AuthLocalDataSourceImpl(this.usersBox, this.storage);

  @override
  Future<Either<Exception, UserModel>> loginOrRegister(
    String phone,
    String password,
  ) async {
    try {
      final existingUser = usersBox.values.cast<UserModel?>().firstWhere(
        (user) => user?.phone == phone,
        orElse: () => null,
      );

      if (existingUser != null) {
        if (existingUser.password == password) {
          await storage.write(key: sessionKey, value: phone);
          return Right(existingUser);
        } else {
          return Left(Exception('Invalid password'));
        }
      }

      final newUser = UserModel(phone: phone, password: password);
      await usersBox.add(newUser);
      await storage.write(key: sessionKey, value: phone);
      return Right(newUser);
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, UserModel?>> checkSession() async {
    try {
      final phone = await storage.read(key: sessionKey);
      if (phone == null) return Right(null);

      final existingUser = usersBox.values.cast<UserModel?>().firstWhere(
        (user) => user?.phone == phone,
        orElse: () => null,
      );
      return Right(existingUser);
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await storage.delete(key: sessionKey);
  }
}
