import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t2_mobile_application/core/config/router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/settings/presentation/bloc/settings_cubit.dart';
import 'package:t2_mobile_application/features/settings/presentation/bloc/settings_state.dart';
import 'package:t2_mobile_application/features/tracking/presentation/bloc/tracking_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  runApp(const MyApp());
}

final class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext _) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: const Size(402, 874),
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: sl<SettingsCubit>()..loadSettings()),
          BlocProvider.value(value: sl<TrackingCubit>()),
          BlocProvider.value(value: sl<GamesCubit>()),
        ],
        child: BlocListener<SettingsCubit, SettingsState>(
          listener: (context, state) {
            if (state is SettingsLoaded) {
              context.read<TrackingCubit>().updateTrackingState(
                geolocationEnabled: state.settings.geolocationEnabled,
                notificationsEnabled: state.settings.notificationsEnabled,
              );
            }
          },
          child: MaterialApp.router(
            routerConfig: router,
            title: 'Удмурт кыл',
            theme: T2Theme.lightTheme,
            darkTheme: T2Theme.darkTheme,
          ),
        ),
      ),
    );
  }
}
