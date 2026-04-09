import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/settings/domain/entities/settings_entity.dart';
import 'package:t2_mobile_application/features/settings/domain/repositories/settings_repository.dart';

@lazySingleton
final class UpdateSettingsUseCase implements UseCase<Either<Exception, void>, SettingsEntity> {
  final SettingsRepository repository;

  const UpdateSettingsUseCase(this.repository);

  @override
  Future<Either<Exception, void>> call(SettingsEntity params) async {
    return await repository.updateSettings(params);
  }
}
