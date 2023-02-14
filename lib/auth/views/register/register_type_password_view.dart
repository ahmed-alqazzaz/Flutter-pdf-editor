import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/enums/auth_page.dart';
import '../../bloc/enums/auth_type.dart';
import '../../generics/generic_auth_view/generic_auth_view.dart';

class RegisterTypePasswordView extends StatelessWidget {
  const RegisterTypePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericAuthView(
      onProceed: () {},
      onBack: () {
        context.read<AuthBloc>().add(AuthEventTypeEmail(
              authType: AuthType.register,
              authPage: AuthPage.onTypingEmailPage,
            ));
      },
    );
  }
}
