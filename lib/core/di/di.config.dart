// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_ce/hive.dart' as _i738;
import 'package:hive_ce/hive_ce.dart' as _i1055;
import 'package:injectable/injectable.dart' as _i526;
import 'package:t2_mobile_application/features/auth/data/datasources/auth_local_data_source.dart'
    as _i93;
import 'package:t2_mobile_application/features/auth/data/datasources/auth_local_data_source_impl.dart'
    as _i292;
import 'package:t2_mobile_application/features/auth/data/models/user_model.dart'
    as _i762;
import 'package:t2_mobile_application/features/auth/data/repositories/auth_repository_impl.dart'
    as _i751;
import 'package:t2_mobile_application/features/auth/domain/repositories/auth_repository.dart'
    as _i536;
import 'package:t2_mobile_application/features/auth/domain/usecases/check_session_usecase.dart'
    as _i709;
import 'package:t2_mobile_application/features/auth/domain/usecases/login_usecase.dart'
    as _i115;
import 'package:t2_mobile_application/features/auth/domain/usecases/logout_usecase.dart'
    as _i208;
import 'package:t2_mobile_application/features/auth/domain/usecases/register_usecase.dart'
    as _i552;
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_cubit.dart'
    as _i135;
import 'package:t2_mobile_application/features/games/data/datasources/games_local_data_source.dart'
    as _i138;
import 'package:t2_mobile_application/features/games/data/datasources/games_local_data_source_impl.dart'
    as _i984;
import 'package:t2_mobile_application/features/games/data/repositories/games_repository_impl.dart'
    as _i776;
import 'package:t2_mobile_application/features/games/domain/repositories/games_repository.dart'
    as _i437;
import 'package:t2_mobile_application/features/games/domain/usecases/game_stats_usecases.dart'
    as _i91;
import 'package:t2_mobile_application/features/games/domain/usecases/get_words_usecase.dart'
    as _i568;
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart'
    as _i124;
import 'package:t2_mobile_application/features/settings/data/datasources/settings_local_data_source.dart'
    as _i770;
import 'package:t2_mobile_application/features/settings/data/models/settings_model.dart'
    as _i774;
import 'package:t2_mobile_application/features/settings/data/repositories/settings_repository_impl.dart'
    as _i466;
import 'package:t2_mobile_application/features/settings/domain/repositories/settings_repository.dart'
    as _i261;
import 'package:t2_mobile_application/features/settings/domain/usecases/get_settings_usecase.dart'
    as _i1043;
import 'package:t2_mobile_application/features/settings/domain/usecases/update_settings_usecase.dart'
    as _i797;
import 'package:t2_mobile_application/features/settings/presentation/bloc/settings_cubit.dart'
    as _i801;
import 'package:t2_mobile_application/features/tracking/data/datasources/tracking_local_data_source.dart'
    as _i897;
import 'package:t2_mobile_application/features/tracking/data/repositories/tracking_repository_impl.dart'
    as _i29;
import 'package:t2_mobile_application/features/tracking/domain/repositories/tracking_repository.dart'
    as _i470;
import 'package:t2_mobile_application/features/tracking/presentation/bloc/tracking_cubit.dart'
    as _i746;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i770.SettingsLocalDataSource>(
      () => _i770.SettingsLocalDataSourceImpl(
        gh<_i738.Box<_i774.SettingsModel>>(),
      ),
    );
    gh.lazySingleton<_i93.AuthLocalDataSource>(
      () => _i292.AuthLocalDataSourceImpl(
        gh<_i738.Box<_i762.UserModel>>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i897.TrackingLocalDataSource>(
      () => _i897.TrackingLocalDataSourceImpl(
        gh<_i738.Box<String>>(instanceName: 'visited_pois_box'),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i261.SettingsRepository>(
      () => _i466.SettingsRepositoryImpl(gh<_i770.SettingsLocalDataSource>()),
    );
    gh.lazySingleton<_i138.GamesLocalDataSource>(
      () => _i984.GamesLocalDataSourceImpl(
        gh<_i1055.Box<String>>(instanceName: 'game_stats_box'),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i470.TrackingRepository>(
      () => _i29.TrackingRepositoryImpl(gh<_i897.TrackingLocalDataSource>()),
    );
    gh.lazySingleton<_i746.TrackingCubit>(
      () => _i746.TrackingCubit(gh<_i470.TrackingRepository>()),
    );
    gh.lazySingleton<_i1043.GetSettingsUseCase>(
      () => _i1043.GetSettingsUseCase(gh<_i261.SettingsRepository>()),
    );
    gh.lazySingleton<_i797.UpdateSettingsUseCase>(
      () => _i797.UpdateSettingsUseCase(gh<_i261.SettingsRepository>()),
    );
    gh.lazySingleton<_i536.AuthRepository>(
      () => _i751.AuthRepositoryImpl(
        localDataSource: gh<_i93.AuthLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i437.GamesRepository>(
      () => _i776.GamesRepositoryImpl(gh<_i138.GamesLocalDataSource>()),
    );
    gh.lazySingleton<_i91.SaveGameResultUseCase>(
      () => _i91.SaveGameResultUseCase(gh<_i437.GamesRepository>()),
    );
    gh.lazySingleton<_i91.GetGameStatsUseCase>(
      () => _i91.GetGameStatsUseCase(gh<_i437.GamesRepository>()),
    );
    gh.lazySingleton<_i568.GetWordsUseCase>(
      () => _i568.GetWordsUseCase(gh<_i437.GamesRepository>()),
    );
    gh.lazySingleton<_i709.CheckSessionUseCase>(
      () => _i709.CheckSessionUseCase(gh<_i536.AuthRepository>()),
    );
    gh.lazySingleton<_i115.LoginUseCase>(
      () => _i115.LoginUseCase(gh<_i536.AuthRepository>()),
    );
    gh.lazySingleton<_i208.LogoutUseCase>(
      () => _i208.LogoutUseCase(gh<_i536.AuthRepository>()),
    );
    gh.lazySingleton<_i552.RegisterUseCase>(
      () => _i552.RegisterUseCase(gh<_i536.AuthRepository>()),
    );
    gh.lazySingleton<_i801.SettingsCubit>(
      () => _i801.SettingsCubit(
        gh<_i1043.GetSettingsUseCase>(),
        gh<_i797.UpdateSettingsUseCase>(),
      ),
    );
    gh.lazySingleton<_i124.GamesCubit>(
      () => _i124.GamesCubit(
        gh<_i568.GetWordsUseCase>(),
        gh<_i91.SaveGameResultUseCase>(),
        gh<_i91.GetGameStatsUseCase>(),
      ),
    );
    gh.lazySingleton<_i135.AuthCubit>(
      () => _i135.AuthCubit(
        gh<_i115.LoginUseCase>(),
        gh<_i552.RegisterUseCase>(),
        gh<_i709.CheckSessionUseCase>(),
        gh<_i208.LogoutUseCase>(),
      ),
    );
    return this;
  }
}
