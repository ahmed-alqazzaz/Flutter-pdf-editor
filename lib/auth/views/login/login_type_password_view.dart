import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';
import '../../bloc/auth_bloc.dart';
import '../../bloc/enums/auth_page.dart';

import '../../generics/generic_auth_view/generic_auth_view.dart';

class LoginTypePasswordView extends StatelessWidget {
  const LoginTypePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericAuthView(
      key: UniqueKey(),
      onProceed: () {
        context.read<AuthBloc>().add(
            AuthEventLogIn(email: "stevehighly@usa.com", password: "XXXXXXXX"));
      },
      onBack: () {
        context.read<AuthBloc>().add(AuthEventTypeEmail(
              authType: AuthType.login,
              authPage: AuthPage.onTypingEmailPage,
            ));
      },
    );
  }
}
