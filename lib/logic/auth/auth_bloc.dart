import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/repository/apiservices/auth_provider.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthProvider authProvider;

  AuthBloc(this.authProvider) : super(AuthInitial()) {
    // Verify user & send OTP
    on<VerifyUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await authProvider.verifyUser(event.phone);
        final otp = res['otp'].toString();
        final userExists = res['user'] == true;
        print("📌 OTP from API: $otp"); // print OTP in console
        emit(
          OtpSentState(otp: otp, userExists: userExists, phone: event.phone),
        );
      } catch (e) {
        emit(AuthFailure("Failed to verify: $e"));
      }
    });

    // Register new user
    on<RegisterUserEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final res = await authProvider.loginRegister(
          event.phone,
          event.firstName,
        );
        final token = res['token'].toString();
        emit(Authenticated(token));
      } catch (e) {
        emit(AuthFailure("Failed to register: $e"));
      }
    });

    // OTP submission (mock check)
    on<SubmitOtpEvent>((event, emit) async {
      if (state is OtpSentState) {
        final current = state as OtpSentState;
        if (event.otp == current.otp) {
          if (current.userExists) {
            // login directly
            emit(AuthLoading());
            try {
              final res = await authProvider.loginRegister(current.phone, "");
              final token = res['token'].toString();
              emit(Authenticated(token));
            } catch (e) {
              emit(AuthFailure("Failed to login: $e"));
            }
          } else {
            // need registration page
            // ⚠️ Here, UI should navigate to Register Screen
            // The Bloc won't auto-navigate — UI listens for state
          }
        } else {
          emit(AuthFailure("Invalid OTP"));
        }
      }
    });

    // Logout
    on<LogoutEvent>((event, emit) async {
      emit(AuthInitial());
    });
  }
}
