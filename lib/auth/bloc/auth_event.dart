import 'dart:ui';

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

class AuthEventTypeEmail extends AuthEvent {
  AuthEventTypeEmail({
    required this.textFieldBorderColor,
    required this.authType,
    required this.isFieldValid,
  });

  final AuthType authType;
  final bool isFieldValid;
  final Color textFieldBorderColor;
}

class AuthEventTypePassword extends AuthEvent {
  AuthEventTypePassword({
    required this.isTextObscure,
    required this.textFieldBorderColor,
    required this.authType,
    required this.isFieldValid,
    this.shouldVisibilityIconShimmer = false,
  });
  final bool isTextObscure;
  final AuthType authType;
  final bool isFieldValid;
  final Color textFieldBorderColor;
  final bool shouldVisibilityIconShimmer;
}
