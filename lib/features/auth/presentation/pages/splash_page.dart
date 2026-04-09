import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_state.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      sl<AuthCubit>().checkSession();
    });
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: BlocListener<AuthCubit, AuthState>(
        listener: (ctx, state) {
          if (state is Authenticated) {
            sl<GamesCubit>().loadStats();
            sl<LessonsCubit>().loadData();
            ctx.go('/home');
          } else if (state is AuthInitial || state is AuthError) {
            ctx.go('/login');
          }
        },
        child: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: T2Theme.magenta),
          ),
        ),
      ),
    );
  }
}
