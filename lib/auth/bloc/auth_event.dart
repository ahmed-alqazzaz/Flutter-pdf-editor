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
    required this.authPage,
    this.textFieldBorderColor = const Color.fromRGBO(186, 186, 186, 100),
    this.isFieldValid = false,
  });

  final AuthType authType;
  final AuthPage authPage;
  final bool isFieldValid;
  final Color textFieldBorderColor;
}

class AuthEventTypeEmail extends AuthEventTypeEmailOrPassword {
  AuthEventTypeEmail({
    required super.authType,
    required super.authPage,
    super.textFieldBorderColor,
    super.isFieldValid,
  });
}

class AuthEventTypePassword extends AuthEventTypeEmailOrPassword {
  AuthEventTypePassword({
    required this.email,
    required super.authType,
    required super.authPage,
    super.isFieldValid,
    super.textFieldBorderColor,
    this.isTextObscure = true,
    this.shouldVisibilityIconShimmer = false,
  });

  final String email;
  final bool isTextObscure;
  final bool shouldVisibilityIconShimmer;
}

// Registeration and logging events

class AuthEventLogOrRegister extends AuthEvent {
  const AuthEventLogOrRegister({
    required this.email,
    required this.password,
  });
  final String email;
  final String password;
}

class AuthEventLogIn extends AuthEventLogOrRegister {
  const AuthEventLogIn({
    required super.email,
    required super.password,
  });
}

class AuthEventRegister extends AuthEventLogOrRegister {
  const AuthEventRegister({
    required super.email,
    required super.password,
  });
}
