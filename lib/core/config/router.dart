import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/features/auth/presentation/pages/login_page.dart';
import 'package:t2_mobile_application/features/auth/presentation/pages/splash_page.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_state.dart';
import 'package:t2_mobile_application/features/games/presentation/pages/choose_translation_page.dart';
import 'package:t2_mobile_application/features/games/presentation/pages/compile_word_page.dart';
import 'package:t2_mobile_application/features/games/presentation/pages/game_result_page.dart';
import 'package:t2_mobile_application/features/games/presentation/pages/games_hub_page.dart';
import 'package:t2_mobile_application/features/games/presentation/pages/true_false_page.dart';
import 'package:t2_mobile_application/features/home/presentation/pages/home_page.dart';
import 'package:t2_mobile_application/features/profile/presentation/pages/profile_page.dart';
import 'package:t2_mobile_application/features/settings/presentation/pages/settings_page.dart';

final rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  debugLogDiagnostics: true,
  initialLocation: '/',
  navigatorKey: rootNavigationKey,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(path: '/settings', builder: (context, state) => const SettingsPage()),
    GoRoute(path: '/profile', builder: (context, state) => const ProfilePage()),
    GoRoute(path: '/games', builder: (context, state) => const GamesHubPage()),
    GoRoute(path: '/games/translate', builder: (context, state) => const ChooseTranslationPage()),
    GoRoute(path: '/games/compile', builder: (context, state) => const CompileWordPage()),
    GoRoute(path: '/games/truefalse', builder: (context, state) => const TrueFalsePage()),
    GoRoute(
      path: '/games/result',
      builder: (context, state) => GameResultPage(result: state.extra as QuizComplete),
    ),
  ],
);
