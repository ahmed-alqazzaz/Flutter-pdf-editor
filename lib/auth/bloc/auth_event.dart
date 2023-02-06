import 'dart:ui';

import 'enums/current_login_page.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventSeekMain extends AuthEvent {
  final bool shouldSkipButtonGlow;
  const AuthEventSeekMain({
    required this.shouldSkipButtonGlow,
  });
}

class AuthEventSeekLogin extends AuthEvent {
  final CurrentLoginPage currentLoginPage;
  final bool isFieldValid;
  final Color textFieldBorderColor;
  AuthEventSeekLogin({
    required this.textFieldBorderColor,
    required this.currentLoginPage,
    required this.isFieldValid,
  });
}
