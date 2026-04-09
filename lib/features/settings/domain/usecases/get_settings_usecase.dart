import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/settings/domain/entities/settings_entity.dart';
import 'package:t2_mobile_application/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
final class GetSettingsUseCase implements UseCase<Either<Exception, SettingsEntity>, NoParams> {
  final SettingsRepository repository;

  const GetSettingsUseCase(this.repository);

  @override
  Future<Either<Exception, SettingsEntity>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
