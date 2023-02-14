import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/auth_service/auth_exceptions.dart';
import 'package:pdf_editor/auth/auth_service/auth_service.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this.navigatorKey) : super(const AuthStateInitial()) {
    on<AuthEventSeekMain>((event, emit) {
      const path = '/auth/main_auth/';
      navigatorKey.currentState?.popUntil((route) {
        currentRoute = route.settings.name;
        if (currentRoute != path) {
          Navigator.of(navigatorKey.currentContext!)
              .pushNamedAndRemoveUntil(path, (route) => false);
        }
        return true;
      });
      emit(
        AuthStateMain(shouldSkipButtonGlow: event.shouldSkipButtonGlow),
      );
    });
    on<AuthEventTypeEmail>(
      (event, emit) async {
        final path = event.authType == AuthType.login
            ? '/auth/login/email/'
            : '/auth/register/email/';

        navigatorKey.currentState?.popUntil((route) {
          currentRoute = route.settings.name;
          if (currentRoute != path) {
            Navigator.of(navigatorKey.currentContext!).pushNamed(path);
          }
          return true;
        });

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
        final path = event.authType == AuthType.login
            ? '/auth/login/password/'
            : '/auth/register/password/';
        navigatorKey.currentState?.popUntil((route) {
          currentRoute = route.settings.name;
          if (currentRoute != path) {
            Navigator.of(navigatorKey.currentContext!).pushNamed(path);
          }
          return true;
        });

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
        print(event.email + event.password);
        emit(AuthStateTypingPassword(
          email: event.email,
          authType: AuthType.login,
          authPage: AuthPage.onTypingPasswordPage,
          isLoading: true,
        ));
        try {
          await AuthService.withEmailAndPassword().initialize();
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

          //TODO: replace email with home
        } catch (e) {
          final exception = GenericAuthException(Exception(e));
          emit(AuthStateTypingPassword(
            email: event.email,
            authType: AuthType.login,
            authPage: AuthPage.onTypingPasswordPage,
            exception: exception,
          ));
        }
        // TODO: MOVE TO NEXT PAGE
      },
    );

    on<AuthEventRegister>(
      (event, emit) async {
        print(event.email + event.password);
        emit(AuthStateTypingPassword(
          email: event.email,
          authType: AuthType.register,
          authPage: AuthPage.onTypingPasswordPage,
          isLoading: true,
        ));
        try {
          await AuthService.withEmailAndPassword().initialize();
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

          //TODO: replace email with home
        } catch (e) {
          final exception = GenericAuthException(Exception(e));
          emit(AuthStateTypingPassword(
            email: event.email,
            authType: AuthType.register,
            authPage: AuthPage.onTypingPasswordPage,
            exception: exception,
          ));
        }
        // TODO: MOVE TO NEXT PAGE
      },
    );
  }

  String? currentRoute;
  final GlobalKey<NavigatorState> navigatorKey;
}
