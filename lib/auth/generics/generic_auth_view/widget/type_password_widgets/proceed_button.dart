import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_state.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import '../../../../bloc/auth_bloc.dart';
import '../../../../bloc/auth_event.dart';
import '../../../../bloc/enums/auth_page.dart';
import '../../../buttons/enums/button.dart';
import '../../../buttons/generic_button.dart';
import '../../../buttons/generic_child.dart';
import '../../generic_auth_view.dart';

class TypePasswordProceedButtonn extends StatefulWidget {
  const TypePasswordProceedButtonn({super.key, required this.controller});
  final TextEditingController controller;
  @override
  State<TypePasswordProceedButtonn> createState() =>
      _TypePasswordProceedButtonnState();
}

class _TypePasswordProceedButtonnState
    extends State<TypePasswordProceedButtonn> {
  late final AuthBloc authBloc;

  AuthStateTypingPassword? state;
  @override
  void didChangeDependencies() {
    authBloc = context.read<AuthBloc>();

    super.didChangeDependencies();
  }

  void proceed() {
    final password = widget.controller.text;
    if (state!.authType == AuthType.login) {
      authBloc.add(AuthEventLogIn(
        email: state!.email,
        password: password,
      ));
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    state = authBloc.state as AuthStateTypingPassword;
    print("isfieldvalid :${state!.isFieldValid}");
    return GenericButton(
      backgroundColor: state!.isFieldValid
          ? MaterialStateProperty.all(
              Colors.deepPurple,
            )
          : MaterialStateProperty.all(const Color.fromRGBO(186, 186, 186, 1)),
      onPressed: state!.isFieldValid ? proceed : null,
      child: GenericChild(
        button:
            state!.authType == AuthType.login ? Button.login : Button.register,
      ),
    );
  }
}
