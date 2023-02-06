import 'package:flutter/material.dart';

import '../../bloc/enums/auth_type.dart';
import '../../generics/views/generic_type_email_view.dart';

class RegisterTypeEmailView extends StatelessWidget {
  const RegisterTypeEmailView({super.key});

  @override
  Widget build(BuildContext context) {
    return GenericTypeEmailView(
      authType: AuthType.register,
      onNext: () {
        print("hhhh");
      },
    );
  }
}
