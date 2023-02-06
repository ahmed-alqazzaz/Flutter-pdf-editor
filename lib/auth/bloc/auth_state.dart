import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

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
  const AuthStateMain({required this.shouldSkipButtonGlow});

  final bool shouldSkipButtonGlow;

  @override
  List<Object?> get props => [shouldSkipButtonGlow];
}

class AuthStateTypingEmail extends AuthState {
  const AuthStateTypingEmail({
    required this.textFieldBorderColor,
    required this.authType,
    required this.isFieldValid,
  });

  final AuthType authType;
  final bool isFieldValid;
  final Color textFieldBorderColor;

  @override
  List<Object?> get props => [authType, isFieldValid, textFieldBorderColor];
}
