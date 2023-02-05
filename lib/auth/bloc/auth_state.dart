import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf_editor/auth/bloc/enums/current_login_page.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateMain extends AuthState {
  final bool shouldSkipButtonGlow;

  const AuthStateMain({required this.shouldSkipButtonGlow});
  @override
  List<Object?> get props => [shouldSkipButtonGlow];
}

class AuthStateLoggingIn extends AuthState {
  final CurrentLoginPage currentLoginPage;
  final bool isFieldValid;
  const AuthStateLoggingIn({
    required this.currentLoginPage,
    required this.isFieldValid,
  });
  @override
  List<Object?> get props => [currentLoginPage, isFieldValid];
}
