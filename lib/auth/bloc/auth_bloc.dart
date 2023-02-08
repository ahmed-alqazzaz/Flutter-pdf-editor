import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
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
    on<AuthEventTypeEmail>(
      (event, emit) async {
        navigatorKey.currentState?.popUntil((route) {
          currentRoute = route.settings.name;
          if (currentRoute != '/auth/login/email/') {
            Navigator.of(navigatorKey.currentContext!)
                .pushNamed('/auth/login/email/');
          }
          return true;
        });

        emit(AuthStateTypingEmail(
          authType: event.authType,
          textFieldBorderColor: event.textFieldBorderColor,
          authPage: event.authPage,
          isFieldValid: event.isFieldValid,
        ));
      },
    );
    on<AuthEventTypePassword>(
      (event, emit) async {
        navigatorKey.currentState?.popUntil((route) {
          currentRoute = route.settings.name;
          if (currentRoute != '/auth/login/password/') {
            Navigator.of(navigatorKey.currentContext!)
                .pushNamed('/auth/login/password/');
          }
          return true;
        });

        emit(AuthStateTypingPassword(
          authType: event.authType,
          shouldVisibilityIconShimmer: event.shouldVisibilityIconShimmer,
          isTextObscure: event.isTextObscure,
          textFieldBorderColor: event.textFieldBorderColor,
          authPage: event.authPage,
          isFieldValid: event.isFieldValid,
        ));
      },
    );
  }

  String? currentRoute;
  final GlobalKey<NavigatorState> navigatorKey;
}
