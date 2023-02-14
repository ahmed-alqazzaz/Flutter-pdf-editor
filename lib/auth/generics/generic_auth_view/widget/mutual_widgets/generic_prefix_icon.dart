import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_state.dart';

import '../../../../bloc/auth_bloc.dart';

class GenericPrefixIcon extends StatelessWidget {
  const GenericPrefixIcon({super.key});

  @override
  Widget build(BuildContext context) {
    // this does'nt work on some old devices because the the textfield widget might not be fully disposed when clicking the back button while the state will change to authstatemain resulting in cast error
    final state =
        context.read<AuthBloc>().state as AuthStateTypingEmailOrPassword;
    return Container(
      alignment: const Alignment(-1, 0.5),
      width: 1,
      child: Icon(
        size: 20,
        color: Colors.black,
        state is AuthStateTypingEmail
            ? Icons.email_outlined
            : Icons.lock_outline_sharp,
      ),
    );
  }
}
