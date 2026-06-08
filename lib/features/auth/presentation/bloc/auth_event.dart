part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthStarted extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested(this.email, this.password);
  final String email;
  final String password;
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested(this.name, this.email, this.password);
  final String name;
  final String email;
  final String password;
  @override
  List<Object?> get props => [name, email, password];
}

class AuthGoogleRequested extends AuthEvent {}

class AuthGuestRequested extends AuthEvent {}

class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested(this.email);
  final String email;
  @override
  List<Object?> get props => [email];
}

class AuthLogoutRequested extends AuthEvent {}

class _AuthUserChanged extends AuthEvent {
  const _AuthUserChanged(this.user);
  final AppUser? user;
  @override
  List<Object?> get props => [user];
}
