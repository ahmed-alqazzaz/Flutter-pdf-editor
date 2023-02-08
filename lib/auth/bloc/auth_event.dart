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
