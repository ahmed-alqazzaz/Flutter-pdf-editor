import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';

import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';
import 'package:pdf_editor/auth/generics/views/generic_type_email_view.dart';

import '../../bloc/auth_bloc.dart';
import '../../generics/views/generic_auth_view.dart';

class LoginTypeEmailView extends StatelessWidget {
  const LoginTypeEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericAuthView(
      authPage: AuthPage.onTypingEmailPage,
      authType: AuthType.login,
      onProceed: () {
        context.read<AuthBloc>().add(
              AuthEventTypePassword(
                isTextObscure: false,
                textFieldBorderColor: const Color.fromRGBO(186, 186, 186, 100),
                authPage: AuthPage.onTypingPasswordPage,
                isFieldValid: false,
                authType: AuthType.login,
              ),
            );
      },
    );
  }
}
