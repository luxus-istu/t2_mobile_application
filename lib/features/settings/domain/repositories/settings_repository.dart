import 'package:dartz/dartz.dart';
import 'package:t2_mobile_application/features/settings/domain/entities/settings_entity.dart';

abstract interface class SettingsRepository {
  Future<Either<Exception, SettingsEntity>> getSettings();
  Future<Either<Exception, void>> updateSettings(SettingsEntity settings);
}
