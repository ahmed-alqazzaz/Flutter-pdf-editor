import 'package:flutter/material.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import '../../buttons/enums/button.dart';
import '../../buttons/generic_button.dart';
import '../../buttons/generic_child.dart';
import '../generic_auth_view.dart';

class TypePasswordProceedButton extends StatelessWidget {
  const TypePasswordProceedButton({
    super.key,
    required this.onProceed,
    required this.isFieldValid,
    required this.authType,
  });

  final OnPressed onProceed;
  final bool isFieldValid;
  final AuthType authType;
  @override
  Widget build(BuildContext context) {
    return GenericButton(
      backgroundColor: isFieldValid
          ? MaterialStateProperty.all(
              Colors.deepPurple,
            )
          : MaterialStateProperty.all(const Color.fromRGBO(186, 186, 186, 1)),
      onPressed: isFieldValid ? onProceed : null,
      child: GenericChild(
        button: authType == AuthType.login ? Button.login : Button.register,
      ),
    );
  }
}
