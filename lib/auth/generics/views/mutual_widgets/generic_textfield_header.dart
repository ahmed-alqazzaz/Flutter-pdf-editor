import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pdf_editor/auth/bloc/auth_state.dart';

class GenericTextFieldHeader extends StatelessWidget {
  GenericTextFieldHeader({super.key, required this.state});

  AuthStateTypingEmailOrPassword state;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          state is AuthStateTypingEmail ? "Enter your email" : "Now your email",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
