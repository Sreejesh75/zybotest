abstract class AuthEvent {}

class VerifyUserEvent extends AuthEvent {
  final String phone;
  VerifyUserEvent(this.phone);
}

class SubmitOtpEvent extends AuthEvent {
  final String otp;
  SubmitOtpEvent(this.otp);
}

class RegisterUserEvent extends AuthEvent {
  final String phone;
  final String firstName;
  RegisterUserEvent(this.phone, this.firstName);
}

class LogoutEvent extends AuthEvent {}
