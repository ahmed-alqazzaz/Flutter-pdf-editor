import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/auth_service/auth_service.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import 'package:pdf_editor/auth/auth_service/firebase_auth_provider.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';
import 'package:pdf_editor/auth/generics/generic_auth_view/generic_auth_view.dart';
import 'package:pdf_editor/auth/views/navigator.dart';
import 'package:pdf_editor/helpers/error_messages/show_error_message.dart';

import '../../auth_service/auth_exceptions.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';

import '../../generics/buttons/generic_button.dart';
import '../../generics/buttons/generic_child.dart';
import '../../generics/buttons/enums/button.dart';
import '../error_messages.dart';
import '../login/login_type_email_view.dart';
import '../login/login_type_password_view.dart';
import '../register/register_type_email_view.dart';
import '../register/register_type_password_view.dart';

class MainAuthScreen extends StatelessWidget {
  const MainAuthScreen({super.key, required this.navigatorKey});
  final GlobalKey<NavigatorState> navigatorKey;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(navigatorKey),
      child: MainAuthView(),
    );
  }
}

class MainAuthView extends StatelessWidget {
  const MainAuthView({super.key});

  static const Color skipButtonDefaultColor =
      Color.fromARGB(255, 115, 112, 112);
  static const Color skipButtonSelectedColor = Colors.black;

  Widget _loginWithFacebookButton() {
    return Builder(
      builder: (context) {
        return GenericButton(
          onPressed: () async =>
              context.read<AuthBloc>().add(const AuthEventLoginWithFacebook()),
          child: const GenericChild(button: Button.facebook),
        );
      },
    );
  }

  Widget _loginWithGoogleButton() {
    return Builder(
      builder: (context) {
        return GenericButton(
          onPressed: () async =>
              context.read<AuthBloc>().add(const AuthEventLoginWithGoogle()),
          child: const GenericChild(button: Button.google),
        );
      },
    );
  }

  Widget _loginWithAppleButton() {
    return Builder(
      builder: (context) {
        return GenericButton(
          onPressed: () async =>
              context.read<AuthBloc>().add(const AuthEventLoginWithApple()),
          child: const GenericChild(button: Button.apple),
        );
      },
    );
  }

  Widget _loginWithEmailAndPasswordButton() {
    return Builder(builder: (context) {
      return GenericButton(
        backgroundColor: MaterialStateProperty.all(
          Colors.deepPurple,
        ),
        onPressed: () async {
          context.read<AuthBloc>().add(
                AuthEventTypeEmail(
                  authType: AuthType.login,
                  authPage: AuthPage.onTypingEmailPage,
                ),
              );
        },
        child: const GenericChild(
          button: Button.login,
        ),
      );
    });
  }

  Widget skipButton() {
    return Builder(builder: (context) {
      return TextButton(
        onPressed: () {
          context.read<AuthBloc>().add(const AuthEventLoginAnonymously());
        },
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) =>
                states.contains(MaterialState.pressed)
                    ? skipButtonSelectedColor
                    : skipButtonDefaultColor,
          ),
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
        ),
        child: const Text("Skip for now"),
      );
    });
  }

  Widget _registerWithEmailAndPasswordButton() {
    return Builder(builder: (context) {
      return GenericButton(
        onPressed: () {
          context.read<AuthBloc>().add(
                AuthEventTypeEmail(
                  authType: AuthType.register,
                  authPage: AuthPage.onTypingEmailPage,
                ),
              );
        },
        child: const GenericChild(
          button: Button.createAccount,
        ),
      );
    });
  }

  Widget _pageDivider() {
    return LayoutBuilder(builder: (context, constraints) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Expanded(
            child: Divider(
              height: 2.0,
              color: Color.fromARGB(255, 115, 112, 112),
              thickness: 0.8,
            ),
          ),
          SizedBox(width: constraints.maxWidth * 0.02),
          const Text(
            "or",
            style: TextStyle(
                color: Color.fromARGB(255, 99, 95, 95),
                fontSize: 18,
                fontWeight: FontWeight.w400),
          ),
          SizedBox(width: constraints.maxWidth * 0.02),
          const Expanded(
            child: Divider(
              height: 2.0,
              color: Color.fromARGB(255, 126, 122, 122),
              thickness: 0.8,
            ),
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return AuthNavigator(
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthStateMain) {
              if (state.exception != null) {
                showErrorMessage(
                  context: context,
                  text: errorMessages[state.exception.runtimeType] ??
                      "Unknown error",
                  duration: const Duration(seconds: 3),
                );
              }
            }
          },
          child: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: width * 0.04),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: height * 0.22),
                    _loginWithFacebookButton(),
                    _loginWithGoogleButton(),
                    _loginWithAppleButton(),
                    SizedBox(height: height * 0.04),
                    _pageDivider(),
                    SizedBox(height: height * 0.04),
                    _loginWithEmailAndPasswordButton(),
                    _registerWithEmailAndPasswordButton(),
                    SizedBox(height: height * 0.13),
                    skipButton(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
