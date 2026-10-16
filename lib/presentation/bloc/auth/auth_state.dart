abstract class AuthState {}

class AuthInitial extends AuthState {}

class SignInLoading extends AuthState {}
class SignInSuccess extends AuthState {
  final String message;
  // final AccountRole accountRole;
  SignInSuccess({required this.message,
    // required this.accountRole
  });
}
class SignInFailure extends AuthState {
  final String message;
  SignInFailure(this.message);
}


class ForgotPasswordLoading extends AuthState {}
class ForgotPasswordSuccess extends AuthState {
  final String message;
  ForgotPasswordSuccess({required this.message});
}
class ForgotPasswordFailure extends AuthState {
  final String message;
  ForgotPasswordFailure(this.message);
}

class LogoutLoading extends AuthState {}
class LogoutSuccess extends AuthState {}
class LogoutFailure extends AuthState {
  final String message;
  LogoutFailure(this.message);
}

class UnauthenticatedState extends AuthState {}
