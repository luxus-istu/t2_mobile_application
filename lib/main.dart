import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:t2_mobile_application/core/config/router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';

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
      child: MaterialApp.router(
        routerConfig: router,
        title: 'T2 Mobile',
        supportedLocales: const [Locale('ru')],
        themeMode: ThemeMode.dark,
        darkTheme: T2Theme.darkTheme,
      ),
    );
  }
}
