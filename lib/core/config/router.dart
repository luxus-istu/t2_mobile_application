import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/features/auth/presentation/pages/login_page.dart';
import 'package:t2_mobile_application/features/auth/presentation/pages/splash_page.dart';
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
  ],
);
