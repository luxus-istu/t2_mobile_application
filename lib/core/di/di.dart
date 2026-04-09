import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/features/auth/data/models/user_model.dart';
import 'package:t2_mobile_application/features/settings/data/models/settings_model.dart';
import 'package:t2_mobile_application/hive_registrar.g.dart';

import './di.config.dart';

final sl = GetIt.instance;

@InjectableInit()
Future<void> configureDependencies() async {
  await Hive.initFlutter();
  Hive.registerAdapters();

  sl.registerSingleton<FlutterSecureStorage>(const FlutterSecureStorage());

  final usersBox = await Hive.openBox<UserModel>('users_box');
  sl.registerSingleton<Box<UserModel>>(
    usersBox,
    dispose: (param) => param.close(),
  );

  final settingsBox = await Hive.openBox<SettingsModel>('settings_box');
  sl.registerSingleton<Box<SettingsModel>>(
    settingsBox,
    dispose: (param) => param.close(),
  );

  final visitedPoisBox = await Hive.openBox<String>('visited_pois_box');
  sl.registerSingleton<Box<String>>(
    visitedPoisBox,
    instanceName: 'visited_pois_box',
    dispose: (param) => param.close(),
  );

  final gameStatsBox = await Hive.openBox<String>('game_stats_box');
  sl.registerSingleton<Box<String>>(
    gameStatsBox,
    instanceName: 'game_stats_box',
    dispose: (param) => param.close(),
  );

  sl.init();
}
