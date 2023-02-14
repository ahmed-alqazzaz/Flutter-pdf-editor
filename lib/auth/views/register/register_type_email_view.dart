import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';

import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import '../../bloc/auth_bloc.dart';
import '../../generics/generic_auth_view/generic_auth_view.dart';

class RegisterTypeEmailView extends StatelessWidget {
  const RegisterTypeEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericAuthView(
      onProceed: () {
        context.read<AuthBloc>().add(
              AuthEventTypePassword(
                email: 'todo',
                authPage: AuthPage.onTypingPasswordPage,
                authType: AuthType.register,
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
