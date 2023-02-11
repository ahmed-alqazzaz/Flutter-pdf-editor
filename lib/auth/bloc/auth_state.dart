import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';

import 'enums/auth_type.dart';

@immutable
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateMain extends AuthState {
  const AuthStateMain({required this.shouldSkipButtonGlow});

  final bool shouldSkipButtonGlow;

  @override
  List<Object> get props => [shouldSkipButtonGlow];
}

// Typing email and password states
class AuthStateTypingEmailOrPassword extends AuthState {
  const AuthStateTypingEmailOrPassword({
    required this.authType,
    required this.textFieldBorderColor,
    required this.authPage,
    required this.isFieldValid,
  });

  final AuthPage authPage;
  final AuthType authType;

  final bool isFieldValid;
  final Color textFieldBorderColor;

  @override
  List<Object> get props => [
        authType,
        authPage,
        isFieldValid,
        textFieldBorderColor,
      ];
}

class AuthStateTypingEmail extends AuthStateTypingEmailOrPassword {
  const AuthStateTypingEmail({
    required super.authType,
    required super.textFieldBorderColor,
    required super.authPage,
    required super.isFieldValid,
  });
}

class AuthStateTypingPassword extends AuthStateTypingEmailOrPassword {
  const AuthStateTypingPassword({
    required this.isTextObscure,
    required super.authType,
    required super.textFieldBorderColor,
    required super.authPage,
    required super.isFieldValid,
    required this.shouldVisibilityIconShimmer,
  });

  final bool isTextObscure;
  final bool shouldVisibilityIconShimmer;

  @override
  List<Object> get props => [
        authType,
        authPage,
        isFieldValid,
        textFieldBorderColor,
        isTextObscure,
        shouldVisibilityIconShimmer,
      ];
}

// Registeration and  logging  states
class AuthStateLoggingOrRegistering extends AuthState {
  const AuthStateLoggingOrRegistering(
      {required this.email, required this.password, required this.isLoading});
  final String email;
  final String password;
  final bool isLoading;
  @override
  List<Object> get props => [email, password, isLoading];
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
