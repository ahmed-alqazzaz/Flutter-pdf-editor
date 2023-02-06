import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GlobalKey<NavigatorState> navigatorKey;
  String? currentRoute;

  AuthBloc(this.navigatorKey) : super(const AuthStateInitial()) {
    on<AuthEventSeekMain>((event, emit) {
      navigatorKey.currentState?.popUntil((route) {
        currentRoute = route.settings.name;
        if (currentRoute != '/auth/main_auth/') {
          Navigator.of(navigatorKey.currentContext!)
              .pushNamed('/auth/main_auth/');
        }
        return true;
      });
      emit(
        AuthStateMain(shouldSkipButtonGlow: event.shouldSkipButtonGlow),
      );
    });
    on<AuthEventSeekLogin>(
      (event, emit) async {
        navigatorKey.currentState?.popUntil((route) {
          currentRoute = route.settings.name;
          if (currentRoute != '/auth/login/email/') {
            Navigator.of(navigatorKey.currentContext!)
                .pushNamed('/auth/login/email/');
          }
          return true;
        });

        emit(AuthStateLoggingIn(
          textFieldBorderColor: event.textFieldBorderColor,
          currentLoginPage: event.currentLoginPage,
          isFieldValid: event.isFieldValid,
        ));
      },
    );
  }
}
