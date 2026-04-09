import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:t2_mobile_application/core/usecases/usecase.dart';
import 'package:t2_mobile_application/features/auth/domain/usecases/check_session_usecase.dart';
import 'package:t2_mobile_application/features/auth/domain/usecases/login_usecase.dart';
import 'package:t2_mobile_application/features/auth/domain/usecases/logout_usecase.dart';
import 'package:t2_mobile_application/features/auth/presentation/bloc/auth_state.dart';

@lazySingleton
final class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase _loginUseCase;
  final CheckSessionUseCase _checkSessionUseCase;
  final LogoutUseCase _logoutUseCase;

  AuthCubit(this._loginUseCase, this._checkSessionUseCase, this._logoutUseCase)
    : super(const AuthInitial());

  Future<void> checkSession() async {
    emit(const AuthLoading());

    final result = await _checkSessionUseCase(const NoParams());

    result.fold(
      (failure) => emit(const AuthInitial()),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> submit(String phone, String password) async {
    if (phone.isEmpty || password.isEmpty) {
      emit(const AuthError('Поля не могут быть пустыми'));
      return;
    }

    emit(const AuthLoading());

    final result = await _loginUseCase(
      LoginParams(phone: phone, password: password),
    );

    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    await _logoutUseCase(const NoParams());
    emit(const AuthInitial());
  }
}
