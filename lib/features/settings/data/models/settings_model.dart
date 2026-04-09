import 'package:hive_ce/hive_ce.dart';
import 'package:t2_mobile_application/features/settings/domain/entities/settings_entity.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 1)
class SettingsModel extends HiveObject {
  @HiveField(0)
  bool soundEnabled;

  @HiveField(1)
  bool notificationsEnabled;

  @HiveField(2)
  bool geolocationEnabled;

  SettingsModel({
    this.soundEnabled = true,
    this.notificationsEnabled = true,
    this.geolocationEnabled = false,
  });

  factory SettingsModel.fromEntity(SettingsEntity entity) {
    return SettingsModel(
      soundEnabled: entity.soundEnabled,
      notificationsEnabled: entity.notificationsEnabled,
      geolocationEnabled: entity.geolocationEnabled,
    );
  }

  SettingsEntity toEntity() {
    return SettingsEntity(
      soundEnabled: soundEnabled,
      notificationsEnabled: notificationsEnabled,
      geolocationEnabled: geolocationEnabled,
    );
  }
}
