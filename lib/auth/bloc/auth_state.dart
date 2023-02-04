import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

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
