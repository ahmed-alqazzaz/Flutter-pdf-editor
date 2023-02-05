import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthStateInitial()) {
    on<AuthEventSeekMain>((event, emit) {
      emit(
        AuthStateMain(shouldSkipButtonGlow: event.shouldSkipButtonGlow),
      );
    });
    on<AuthEventSeekLogin>(
      (event, emit) {
        print("worked");
        emit(AuthStateLoggingIn(
          currentLoginPage: event.currentLoginPage,
          isFieldValid: event.isFieldValid,
        ));
      },
    );
  }
}
