import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/auth_service/auth_exceptions.dart';
import 'package:pdf_editor/auth/auth_service/auth_service.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthStateInitial()) {
    on<AuthEventSeekMain>((event, emit) => emit(const AuthStateMain()));
    on<AuthEventTypeEmail>(
      (event, emit) async {
        emit(AuthStateTypingEmail(
          authType: event.authType,
          textFieldBorderColor: event.textFieldBorderColor,
          authPage: event.authPage,
          isFieldValid: event.isFieldValid,
        ));
      },
    );
    on<AuthEventTypePassword>(
      (event, emit) async {
        emit(AuthStateTypingPassword(
          email: event.email,
          authType: event.authType,
          shouldVisibilityIconShimmer: event.shouldVisibilityIconShimmer,
          isTextObscure: event.isTextObscure,
          textFieldBorderColor: event.textFieldBorderColor,
          authPage: event.authPage,
          isFieldValid: event.isFieldValid,
        ));
      },
    );
    on<AuthEventLogIn>(
      (event, emit) async {
        emit(AuthStateTypingPassword(
          email: event.email,
          authType: AuthType.login,
          authPage: AuthPage.onTypingPasswordPage,
          isLoading: true,
        ));
        try {
          await AuthService.withEmailAndPassword().signIn(
            email: event.email,
            password: event.password,
          );
        } on Exception catch (exception) {
          emit(AuthStateTypingPassword(
            email: event.email,
            authType: AuthType.login,
            authPage: AuthPage.onTypingPasswordPage,
            exception: exception,
          ));
        } catch (e) {
          final exception = GenericAuthException(Exception(e));
          emit(AuthStateTypingPassword(
            email: event.email,
            authType: AuthType.login,
            authPage: AuthPage.onTypingPasswordPage,
            exception: exception,
          ));
        }
      },
    );

    on<AuthEventRegister>(
      (event, emit) async {
        emit(AuthStateTypingPassword(
          email: event.email,
          authType: AuthType.register,
          authPage: AuthPage.onTypingPasswordPage,
          isLoading: true,
        ));
        try {
          await AuthService.withEmailAndPassword().createUser(
            email: event.email,
            password: event.password,
          );
        } on Exception catch (exception) {
          emit(AuthStateTypingPassword(
            email: event.email,
            authType: AuthType.register,
            authPage: AuthPage.onTypingPasswordPage,
            exception: exception,
          ));
        } catch (e) {
          final exception = GenericAuthException(Exception(e));
          emit(AuthStateTypingPassword(
            email: event.email,
            authType: AuthType.register,
            authPage: AuthPage.onTypingPasswordPage,
            exception: exception,
          ));
        }
      },
    );

    on<AuthEventLoginWithGoogle>(
      (event, emit) async {
        try {
          await AuthService.withGoogle().signIn();
        } on Exception catch (e) {
          emit(AuthStateMain(e));
        }
      },
    );
    on<AuthEventLoginWithFacebook>(
      (event, emit) async {
        try {
          await AuthService.withFacebook().signIn();
        } on Exception catch (e) {
          log(e.toString());
          emit(AuthStateMain(e));
        }
      },
    );
    on<AuthEventLoginWithApple>(
      (event, emit) async {
        try {
          await AuthService.withApple().signIn();
        } on Exception catch (e) {
          emit(AuthStateMain(e));
        }
      },
    );
    on<AuthEventLoginAnonymously>(
      (event, emit) async {
        try {
          await AuthService.withAnonymous().signIn();
        } on Exception catch (e) {
          emit(AuthStateMain(e));
        }
      },
    );
  }
}
