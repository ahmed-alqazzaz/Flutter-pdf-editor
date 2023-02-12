import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';

import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import '../../../helpers/loading/loading_screen.dart';
import '../../bloc/auth_bloc.dart';
import '../../generics/views/generic_auth_view.dart';

class LoginTypeEmailView extends StatelessWidget {
  const LoginTypeEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1)).then((value) {
      LoadingScreen().show(context: context, text: "hhh");
    });
    return GenericAuthView(
      onProceed: () {
        context.read<AuthBloc>().add(
              AuthEventTypePassword(
                isTextObscure: true,
                textFieldBorderColor: const Color.fromRGBO(186, 186, 186, 100),
                authPage: AuthPage.onTypingPasswordPage,
                isFieldValid: false,
                authType: AuthType.login,
              ),
            );
      },
      onBack: () {
        context
            .read<AuthBloc>()
            .add(const AuthEventSeekMain(shouldSkipButtonGlow: false));
      },
    );
  }
}
