part of 'auth_bloc.dart';

enum AuthStatus { unknown, authenticated, unauthenticated, failure }

class AuthState extends Equatable {
  const AuthState({
    required this.status,
    this.user,
    this.isLoading = false,
    this.message,
  });

  const AuthState.unknown() : this(status: AuthStatus.unknown);
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);
  const AuthState.authenticated(AppUser user)
      : this(status: AuthStatus.authenticated, user: user);
  const AuthState.failure(String message)
      : this(status: AuthStatus.failure, message: message);

  final AuthStatus status;
  final AppUser? user;
  final bool isLoading;
  final String? message;

  AuthState copyWith({bool? isLoading, String? message}) {
    return AuthState(
      status: status,
      user: user,
      isLoading: isLoading ?? this.isLoading,
      message: message,
    );
  }

  @override
  List<Object?> get props => [status, user, isLoading, message];
}
