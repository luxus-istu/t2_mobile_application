import 'package:dartz/dartz.dart';
import 'package:hive_ce/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/settings/data/models/settings_model.dart';

abstract interface class SettingsLocalDataSource {
  Future<Either<Exception, SettingsModel>> getSettings();
  Future<Either<Exception, void>> updateSettings(SettingsModel settings);
}

@LazySingleton(as: SettingsLocalDataSource)
final class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const String settingsKey = 'app_settings_key';
  final Box<SettingsModel> settingsBox;

  const SettingsLocalDataSourceImpl(this.settingsBox);

  @override
  Future<Either<Exception, SettingsModel>> getSettings() async {
    try {
      final settings = settingsBox.get(settingsKey);
      if (settings != null) {
        return Right(settings);
      }
      final defaultSettings = SettingsModel();
      await settingsBox.put(settingsKey, defaultSettings);
      return Right(defaultSettings);
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, void>> updateSettings(SettingsModel settings) async {
    try {
      await settingsBox.put(settingsKey, settings);
      return const Right(null);
    } on Exception catch (e) {
      return Left(e);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }
}
