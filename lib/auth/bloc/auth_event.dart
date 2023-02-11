import 'dart:ui';

import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventSeekMain extends AuthEvent {
  const AuthEventSeekMain({
    required this.shouldSkipButtonGlow,
  });

  final bool shouldSkipButtonGlow;
}

// Type email and password events
class AuthEventTypeEmailOrPassword extends AuthEvent {
  AuthEventTypeEmailOrPassword({
    required this.authType,
    required this.textFieldBorderColor,
    required this.authPage,
    required this.isFieldValid,
  });

  final AuthType authType;
  final AuthPage authPage;
  final bool isFieldValid;
  final Color textFieldBorderColor;
}

class AuthEventTypeEmail extends AuthEventTypeEmailOrPassword {
  AuthEventTypeEmail({
    required super.authType,
    required super.textFieldBorderColor,
    required super.authPage,
    required super.isFieldValid,
  });
}

class AuthEventTypePassword extends AuthEventTypeEmailOrPassword {
  AuthEventTypePassword({
    required super.authType,
    required this.isTextObscure,
    required super.textFieldBorderColor,
    required super.authPage,
    required super.isFieldValid,
    this.shouldVisibilityIconShimmer = false,
  });

  final bool isTextObscure;
  final bool shouldVisibilityIconShimmer;
}

// Registeration and logging events

class AuthStateLoggingOrRegistering extends AuthEvent {
  const AuthStateLoggingOrRegistering({
    required this.email,
    required this.password,
    required this.isLoading,
  });
  final String email;
  final String password;
  final bool isLoading;
}

class AuthStateLoggingIn extends AuthStateLoggingOrRegistering {
  const AuthStateLoggingIn({
    required super.email,
    required super.password,
    required super.isLoading,
  });
}

class AuthStateRegistering extends AuthStateLoggingOrRegistering {
  const AuthStateRegistering({
    required super.email,
    required super.password,
    required super.isLoading,
  });
}
