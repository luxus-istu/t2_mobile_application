import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final rootNavigationKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  debugLogDiagnostics: true,
  initialExtra: '/',
  navigatorKey: rootNavigationKey,
  routes: [],
);
