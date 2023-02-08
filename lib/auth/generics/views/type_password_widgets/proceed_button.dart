import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../buttons/enums/button.dart';
import '../../buttons/generic_button.dart';
import '../../buttons/generic_child.dart';
import '../generic_auth_view.dart';

class TypePasswordProceedButton extends StatelessWidget {
  const TypePasswordProceedButton({
    super.key,
    required this.onProceed,
    required this.isFieldValid,
  });

  final OnProceed onProceed;
  final bool isFieldValid;
  @override
  Widget build(BuildContext context) {
    print(isFieldValid);
    return GenericButton(
      backgroundColor: isFieldValid
          ? MaterialStateProperty.all(
              Colors.deepPurple,
            )
          : MaterialStateProperty.all(const Color.fromRGBO(186, 186, 186, 1)),
      onPressed: isFieldValid ? onProceed : null,
      child: const GenericChild(
        button: Button.login,
      ),
    );
    ;
  }
}
