import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/entities/app_user.dart';
import '../../../../domain/repositories/user_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(const AuthState.unknown()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginRequested>(_onLogin);
    on<AuthRegisterRequested>(_onRegister);
    on<AuthGoogleRequested>(_onGoogle);
    on<AuthGuestRequested>(_onGuest);
    on<AuthForgotPasswordRequested>(_onForgotPassword);
    on<AuthLogoutRequested>(_onLogout);
    on<_AuthUserChanged>((event, emit) => emit(event.user == null
        ? const AuthState.unauthenticated()
        : AuthState.authenticated(event.user!)));
  }

  final UserRepository _repository;
  StreamSubscription<AppUser?>? _subscription;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    await _subscription?.cancel();
    _subscription =
        _repository.authState().listen((user) => add(_AuthUserChanged(user)));
  }

  Future<void> _onLogin(
      AuthLoginRequested event, Emitter<AuthState> emit) async {
    await _run(emit, () => _repository.login(event.email, event.password));
  }

  Future<void> _onRegister(
      AuthRegisterRequested event, Emitter<AuthState> emit) async {
    await _run(emit,
        () => _repository.register(event.name, event.email, event.password));
  }

  Future<void> _onGoogle(
      AuthGoogleRequested event, Emitter<AuthState> emit) async {
    await _run(emit, _repository.loginWithGoogle);
  }

  Future<void> _onGuest(
      AuthGuestRequested event, Emitter<AuthState> emit) async {
    await _run(emit, _repository.loginAsGuest);
  }

  Future<void> _onForgotPassword(
      AuthForgotPasswordRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true, message: null));
    try {
      await _repository.forgotPassword(event.email);
      emit(state.copyWith(
          isLoading: false, message: 'Password reset email sent'));
    } catch (error) {
      emit(AuthState.failure(error.toString()));
    }
  }

  Future<void> _onLogout(
      AuthLogoutRequested event, Emitter<AuthState> emit) async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }

  Future<void> _run(
      Emitter<AuthState> emit, Future<AppUser> Function() action) async {
    emit(state.copyWith(isLoading: true, message: null));
    try {
      final user = await action();
      emit(AuthState.authenticated(user));
    } catch (error) {
      emit(AuthState.failure(error.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
