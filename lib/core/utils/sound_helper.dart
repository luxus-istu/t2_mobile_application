import 'package:audioplayers/audioplayers.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:t2_mobile_application/features/settings/presentation/bloc/settings_state.dart';

class SoundHelper {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> playSound(String assetName) async {
    final state = sl<SettingsCubit>().state;
    if (state is SettingsLoaded && !state.settings.soundEnabled) return;

    await _player.play(AssetSource('audio/$assetName'));
  }
}
