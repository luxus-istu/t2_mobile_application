import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for input formatters
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:t2_mobile_application/core/di/di.dart';
import 'package:t2_mobile_application/core/theme/theme.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_state.dart';
import 'package:t2_mobile_application/features/auth/presentation/widgets/t2_text_field.dart';
import 'package:t2_mobile_application/features/games/presentation/bloc/games_cubit.dart';
import 'package:t2_mobile_application/features/lessons/presentation/bloc/lessons_cubit.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLogin = true;

  // 1. Initialize with +7
  final _phoneCtrl = TextEditingController(text: '+7');
  final _passwordCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  String _gender = 'male';

  @override
  void initState() {
    super.initState();
    // 2. Add listener to lock the +7 prefix
    _phoneCtrl.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    final text = _phoneCtrl.text;
    // If user tries to delete +7, put it back and move cursor to end
    if (!text.startsWith('+7')) {
      _phoneCtrl.value = _phoneCtrl.value.copyWith(
        text: '+7',
        selection: const TextSelection.collapsed(offset: 2),
        composing: TextRange.empty,
      );
    }
  }

  @override
  void dispose() {
    _phoneCtrl.removeListener(_onPhoneChanged);
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    super.dispose();
  }

  // Validation Logic
  bool _isValid() {
    final phone = _phoneCtrl.text.trim();
    // Regex for +7 followed by exactly 10 digits
    final phoneRegex = RegExp(r'^\+7\d{10}$');

    if (!phoneRegex.hasMatch(phone)) {
      _showError('Введите полный номер (+7 и 10 цифр)');
      return false;
    }
    if (_passwordCtrl.text.length < 6) {
      _showError('Пароль должен быть не менее 6 символов');
      return false;
    }
    if (!isLogin) {
      if (_firstNameCtrl.text.trim().isEmpty ||
          _lastNameCtrl.text.trim().isEmpty) {
        _showError('Заполните имя и фамилию');
        return false;
      }
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: T2Theme.white)),
        backgroundColor: T2Theme.magenta,
      ),
    );
  }

  @override
  Widget build(BuildContext ctx) {
    return BlocProvider.value(
      value: sl<AuthCubit>(),
      child: Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (ctx, state) {
            if (state is AuthError) {
              _showError(state.message);
            } else if (state is Authenticated) {
              ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  content: Text('Успешный вход'),
                  backgroundColor: Colors.green,
                ),
              );
              sl<GamesCubit>().loadStats();
              sl<LessonsCubit>().loadData();
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
                        isLogin ? 'ВХОД' : 'РЕГИСТРАЦИЯ',
                        style: Theme.of(ctx).textTheme.displayLarge?.copyWith(
                          color: Theme.of(ctx).colorScheme.onSurface,
                          fontSize: 44.sp,
                          letterSpacing: -2,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        isLogin
                            ? 'Войдите в свой аккаунт T2.'
                            : 'Создайте новый аккаунт T2.',
                        style: TextStyle(
                          color: Theme.of(
                            ctx,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 32.h),
                      if (!isLogin) ...[
                        Row(
                          children: [
                            Expanded(
                              child: T2TextField(
                                label: 'Имя',
                                controller: _firstNameCtrl,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: T2TextField(
                                label: 'Фамилия',
                                controller: _lastNameCtrl,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(ctx).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16.r),
                            border: Border.all(
                              color: Theme.of(
                                ctx,
                              ).colorScheme.onSurface.withValues(alpha: 0.2),
                            ),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _gender,
                              isExpanded: true,
                              dropdownColor: Theme.of(ctx).colorScheme.surface,
                              style: TextStyle(
                                color: Theme.of(ctx).colorScheme.onSurface,
                                fontSize: 16.sp,
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'male',
                                  child: Text('Мужской'),
                                ),
                                DropdownMenuItem(
                                  value: 'female',
                                  child: Text('Женский'),
                                ),
                              ],
                              onChanged: (val) {
                                if (val != null) setState(() => _gender = val);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 16.h),
                      ],
                      T2TextField(
                        label: 'Номер телефона',
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        // Ensure only numbers can be typed after +
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9+]')),
                          LengthLimitingTextInputFormatter(12),
                        ],
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
                                  if (_isValid()) {
                                    if (isLogin) {
                                      ctx.read<AuthCubit>().submitLogin(
                                        _phoneCtrl.text.trim(),
                                        _passwordCtrl.text,
                                      );
                                    } else {
                                      ctx.read<AuthCubit>().submitRegister(
                                        phone: _phoneCtrl.text.trim(),
                                        password: _passwordCtrl.text,
                                        firstName: _firstNameCtrl.text.trim(),
                                        lastName: _lastNameCtrl.text.trim(),
                                        gender: _gender,
                                      );
                                    }
                                  }
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: T2Theme.magenta,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: state is AuthLoading
                              ? const CircularProgressIndicator(
                                  color: T2Theme.white,
                                )
                              : Text(
                                  isLogin ? 'ВОЙТИ' : 'ЗАРЕГИСТРИРОВАТЬСЯ',
                                  style: Theme.of(ctx).textTheme.displayLarge
                                      ?.copyWith(
                                        color: T2Theme.white,
                                        fontSize: 20.sp,
                                      ),
                                ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? 'Нет аккаунта? Зарегистрируйтесь'
                              : 'Уже есть аккаунт? Войдите',
                          style: TextStyle(
                            color: T2Theme.magenta,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
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
