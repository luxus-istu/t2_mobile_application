import 'package:equatable/equatable.dart';

class SettingsEntity extends Equatable {
  final bool soundEnabled;
  final bool notificationsEnabled;
  final bool geolocationEnabled;

  const SettingsEntity({
    this.soundEnabled = true,
    this.notificationsEnabled = true,
    this.geolocationEnabled = false,
  });

  SettingsEntity copyWith({
    bool? soundEnabled,
    bool? notificationsEnabled,
    bool? geolocationEnabled,
  }) {
    return SettingsEntity(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      geolocationEnabled: geolocationEnabled ?? this.geolocationEnabled,
    );
  }

  @override
  List<Object?> get props => [soundEnabled, notificationsEnabled, geolocationEnabled];
}
