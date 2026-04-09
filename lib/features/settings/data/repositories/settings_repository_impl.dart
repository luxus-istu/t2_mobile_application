import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/settings/data/datasources/settings_local_data_source.dart';
import 'package:t2_mobile_application/features/settings/data/models/settings_model.dart';
import 'package:t2_mobile_application/features/settings/domain/entities/settings_entity.dart';
import 'package:t2_mobile_application/features/settings/domain/repositories/settings_repository.dart';

@LazySingleton(as: SettingsRepository)
final class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  const SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Exception, SettingsEntity>> getSettings() async {
    final result = await localDataSource.getSettings();
    return result.fold(
      (exception) => Left(exception),
      (model) => Right(model.toEntity()),
    );
  }

  @override
  Future<Either<Exception, void>> updateSettings(SettingsEntity settings) async {
    return await localDataSource.updateSettings(SettingsModel.fromEntity(settings));
  }
}
