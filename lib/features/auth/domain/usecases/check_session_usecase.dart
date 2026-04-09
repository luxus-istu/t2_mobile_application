import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/auth/domain/entities/user_entity.dart';
import 'package:t2_mobile_application/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class CheckSessionUseCase
    implements UseCase<Either<Exception, UserEntity>, NoParams> {
  final AuthRepository repository;

  const CheckSessionUseCase(this.repository);

  @override
  Future<Either<Exception, UserEntity>> call(NoParams params) async {
    return await repository.checkSession();
  }
}
