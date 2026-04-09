import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:t2_mobile_application/features/settings/presentation/bloc/settings_state.dart';

final class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'НАСТРОЙКИ',
          style: Theme.of(
            ctx,
          ).textTheme.displaySmall?.copyWith(fontSize: 33.sp),
        ),
        backgroundColor: Theme.of(ctx).colorScheme.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(ctx).colorScheme.onSurface),
      ),
      body: BlocBuilder<SettingsCubit, SettingsState>(
        builder: (context, state) {
          if (state is SettingsLoading) {
            return Center(
              child: CircularProgressIndicator(color: T2Theme.magenta),
            );
          }
          if (state is SettingsError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: T2Theme.magenta),
              ),
            );
          }
          if (state is SettingsLoaded) {
            final settings = state.settings;
            return ListView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
              children: [
                _buildSwitchTile(
                  context: context,
                  title: 'Звук',
                  value: settings.soundEnabled,
                  icon: Icons.volume_up_outlined,
                  onChanged: (val) =>
                      context.read<SettingsCubit>().toggleSound(val),
                ),
                _buildSwitchTile(
                  context: context,
                  title: 'Уведомления',
                  value: settings.notificationsEnabled,
                  icon: Icons.notifications_none_outlined,
                  onChanged: (val) =>
                      context.read<SettingsCubit>().toggleNotifications(val),
                ),
                _buildSwitchTile(
                  context: context,
                  title: 'Геолокация',
                  value: settings.geolocationEnabled,
                  icon: Icons.location_on_outlined,
                  onChanged: (val) =>
                      context.read<SettingsCubit>().toggleGeolocation(val),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSwitchTile({
    required BuildContext context,
    required String title,
    required bool value,
    required IconData icon,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: SwitchListTile(
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        secondary: Icon(icon, color: T2Theme.magenta),
        value: value,
        onChanged: onChanged,
        activeThumbColor: T2Theme.magenta,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      ),
    );
  }
}
