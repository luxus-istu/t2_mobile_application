import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/auth/domain/repositories/auth_repository.dart';

@lazySingleton
final class LogoutUseCase implements UseCase<Either<Exception, void>, NoParams> {
  final AuthRepository repository;

  const LogoutUseCase(this.repository);

  @override
  Future<Either<Exception, void>> call(NoParams params) async {
    try {
      await repository.logout();
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    }
  }
}
