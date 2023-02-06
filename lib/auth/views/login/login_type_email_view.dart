import 'package:flutter/material.dart';

import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';
import 'package:pdf_editor/auth/generics/views/generic_type_email_view.dart';

class LoginTypeEmailView extends StatelessWidget {
  const LoginTypeEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericTypeEmailView(
      authType: AuthType.login,
      onNext: () {
        print("hhhh");
      },
    );
  }
}
