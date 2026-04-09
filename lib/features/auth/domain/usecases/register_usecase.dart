import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:t2_mobile_application/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class RegisterUseCase implements UseCase<Either<Exception, UserEntity>, RegisterParams> {
  final AuthRepository repository;

  const RegisterUseCase(this.repository);

  @override
  Future<Either<Exception, UserEntity>> call(RegisterParams params) async {
    return await repository.register(
      params.phone,
      params.password,
      params.firstName,
      params.lastName,
      params.gender,
    );
  }
}

class RegisterParams {
  final String phone;
  final String password;
  final String firstName;
  final String lastName;
  final String gender;

  const RegisterParams({
    required this.phone,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.gender,
  });
}
