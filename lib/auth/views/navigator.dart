import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/views/main_auth/main_auth_view.dart';
import 'package:pdf_editor/auth/views/register/register_type_email_view.dart';
import 'package:pdf_editor/auth/views/register/register_type_password_view.dart';

import '../../helpers/loading/loading_screen.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../bloc/enums/auth_type.dart';
import 'login/login_type_email_view.dart';
import 'login/login_type_password_view.dart';

class AuthNavigator extends StatelessWidget {
  const AuthNavigator({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          previous.runtimeType == current.runtimeType ? false : true,
      listener: (context, state) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) {
              return BlocProvider<AuthBloc>.value(
                value: BlocProvider.of<AuthBloc>(context),
                child: state is AuthStateTypingEmailOrPassword
                    ? state is AuthStateTypingEmail
                        ? state.authType == AuthType.login
                            ? const LoginTypeEmailView()
                            : const RegisterTypeEmailView()
                        : state.authType == AuthType.login
                            ? const LoginTypePasswordView()
                            : const RegisterTypePasswordView()
                    : const MainAuthView(),
              );
            },
          ),
        );
      },
      child: child,
    );
  }
}
