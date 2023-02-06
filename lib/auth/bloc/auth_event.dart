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
