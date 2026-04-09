import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_state.dart';
import 'package:t2_mobile_application/features/auth/presentation/widgets/t2_text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (ctx, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(
                    state.message,
                    style: const TextStyle(color: T2Theme.white),
                  ),
                  backgroundColor: T2Theme.magenta,
                ),
              );
            } else if (state is Authenticated) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                SnackBar(
                  content: Text(
                    'Добро пожаловать, ${state.user.phone}!',
                    style: const TextStyle(color: T2Theme.white),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              ctx.go('/home');
            }
          },
          builder: (ctx, state) {
            return SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'ВХОД',
                        style: Theme.of(ctx).textTheme.displayLarge?.copyWith(
                          color: Theme.of(ctx).colorScheme.onSurface,
                          fontSize: 48.sp,
                          letterSpacing: -2,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Войдите или зарегистрируйтесь автоматически.',
                        style: TextStyle(
                          color: Theme.of(
                            ctx,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 48.h),
                      T2TextField(
                        label: 'Номер телефона',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                      ),
                      SizedBox(height: 16.h),
                      T2TextField(
                        label: 'Пароль',
                        controller: _passwordCtrl,
                        isPassword: true,
                      ),
                      SizedBox(height: 32.h),
                      SizedBox(
                        height: 65.h,
                        child: ElevatedButton(
                          onPressed: state is AuthLoading
                              ? null
                              : () {
                                  ctx.read<AuthCubit>().submit(
                                    _phoneCtrl.text.trim(),
                                    _passwordCtrl.text,
                                  );
                                },
                          child: state is AuthLoading
                              ? const CircularProgressIndicator(
                                  color: T2Theme.white,
                                )
                              : Text(
                                  'ПРОДОЛЖИТЬ',
                                  style: Theme.of(ctx).textTheme.displayLarge
                                      ?.copyWith(
                                        color: T2Theme.white,
                                        fontSize: 18.sp,
                                      ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
