import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/settings/domain/entities/settings_entity.dart';
import 'package:t2_mobile_application/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:t2_mobile_application/features/settings/domain/usecases/update_settings_usecase.dart';
import 'package:t2_mobile_application/features/settings/presentation/bloc/settings_state.dart';

@lazySingleton
final class SettingsCubit extends Cubit<SettingsState> {
  final GetSettingsUseCase _getSettingsUseCase;
  final UpdateSettingsUseCase _updateSettingsUseCase;

  SettingsCubit(
    this._getSettingsUseCase,
    this._updateSettingsUseCase,
  ) : super(const SettingsLoading());

  Future<void> loadSettings() async {
    final result = await _getSettingsUseCase(const NoParams());
    result.fold(
      (error) => emit(SettingsError(error.toString())),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _update(SettingsEntity newSettings) async {
    final result = await _updateSettingsUseCase(newSettings);
    result.fold(
      (error) => emit(SettingsError(error.toString())),
      (_) {
        // Optimistically update
        emit(SettingsLoaded(newSettings));
      },
    );
  }

  void toggleSound(bool value) {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      _update(current.copyWith(soundEnabled: value));
    }
  }

  Future<void> toggleNotifications(bool value) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      if (value) {
        final status = await Permission.notification.request();
        if (status.isGranted) {
          _update(current.copyWith(notificationsEnabled: true));
        } else {
          emit(const SettingsError('В разрешении на уведомления отказано'));
          emit(SettingsLoaded(current)); // Revert
        }
      } else {
        _update(current.copyWith(notificationsEnabled: false));
      }
    }
  }

  Future<void> toggleGeolocation(bool value) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      if (value) {
        final status = await Permission.locationWhenInUse.request();
        if (status.isGranted) {
          _update(current.copyWith(geolocationEnabled: true));
        } else {
          emit(const SettingsError('В доступе к геолокации отказано'));
          emit(SettingsLoaded(current)); // Revert
        }
      } else {
        _update(current.copyWith(geolocationEnabled: false));
      }
    }
  }
}
