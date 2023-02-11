import 'package:flutter/material.dart';
import 'package:pdf_editor/auth/generics/buttons/enums/button.dart';
import 'package:pdf_editor/auth/generics/views/generic_auth_view.dart';

import '../../buttons/generic_button.dart';
import '../../buttons/generic_child.dart';

class TypeEmailProceedButton extends StatelessWidget {
  const TypeEmailProceedButton(
      {super.key, required this.onProceed, required this.isFieldValid});

  final OnPressed onProceed;
  final bool isFieldValid;

  @override
  Widget build(BuildContext context) {
    return GenericButton(
      backgroundColor: isFieldValid
          ? null
          : MaterialStateProperty.all(
              const Color.fromRGBO(250, 250, 250, 100),
            ),
      onPressed: isFieldValid ? onProceed : null,
      child: GenericChild(
        button: isFieldValid ? Button.nextEnabled : Button.nextDisabled,
      ),
    );
  }
}
