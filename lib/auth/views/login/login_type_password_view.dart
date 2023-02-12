import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/enums/auth_page.dart';

import '../../generics/views/generic_auth_view.dart';

class LoginTypePasswordView extends StatelessWidget {
  const LoginTypePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericAuthView(
      onProceed: () {},
      onBack: () {
        context.read<AuthBloc>().add(AuthEventTypeEmail(
              authType: AuthType.login,
              textFieldBorderColor: const Color.fromRGBO(186, 186, 186, 100),
              authPage: AuthPage.onTypingEmailPage,
              isFieldValid: false,
            ));
      },
    );
  }
}
