import 'dart:ui';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthEventSeekMain extends AuthEvent {
  final bool shouldSkipButtonGlow;
  const AuthEventSeekMain({
    required this.shouldSkipButtonGlow,
  });
}
