abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class OtpSentState extends AuthState {
  final String otp;
  final bool userExists;
  final String phone;
  OtpSentState({
    required this.otp,
    required this.userExists,
    required this.phone,
  });
}

class Authenticated extends AuthState {
  final String token;
  Authenticated(this.token);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
