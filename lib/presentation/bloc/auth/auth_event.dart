abstract class AuthEvent {}

class SignInRequestEvent extends AuthEvent {
  final String username;
  final String password;
  SignInRequestEvent({required this.username, required this.password});
}

class ForgotPasswordEvent extends AuthEvent {
  final String username;
  ForgotPasswordEvent({required this.username});
}

class LogoutRequestEvent extends AuthEvent {}

// class SessionExpiredEvent extends AuthEvent {}

