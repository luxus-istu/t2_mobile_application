import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:t2_mobile_application/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class LoginUseCase
    implements UseCase<Either<Exception, UserEntity>, LoginParams> {
  final AuthRepository repository;

  const LoginUseCase(this.repository);

  @override
  Future<Either<Exception, UserEntity>> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}
