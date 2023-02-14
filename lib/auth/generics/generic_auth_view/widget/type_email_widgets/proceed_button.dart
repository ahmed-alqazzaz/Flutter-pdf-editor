import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_bloc.dart';

import 'package:pdf_editor/auth/generics/buttons/enums/button.dart';

import '../../../../bloc/auth_event.dart';
import '../../../../bloc/auth_state.dart';
import '../../../../bloc/enums/auth_page.dart';
import '../../../buttons/generic_button.dart';
import '../../../buttons/generic_child.dart';

class TypeEmailProceedButton extends StatefulWidget {
  const TypeEmailProceedButton({
    super.key,
    required this.controller,
    required this.textFieldListener,
  });

  final TextEditingController controller;
  final void Function() textFieldListener;
  @override
  State<TypeEmailProceedButton> createState() => _TypeEmailProceedButtonState();
}

class _TypeEmailProceedButtonState extends State<TypeEmailProceedButton> {
  late final AuthBloc authBloc;
  AuthStateTypingEmail? state;
  @override
  void didChangeDependencies() {
    authBloc = context.read<AuthBloc>();
    super.didChangeDependencies();
  }

  Future<void> proceed() async {
    // the framework is getting buggy and the textfield is not getting disposed properly so the texfield had to be cleared
    // and the listener had to be removed
    final text = widget.controller.text;
    widget.controller.removeListener(widget.textFieldListener);
    widget.controller.clear();

    authBloc.add(
      AuthEventTypePassword(
        email: text,
        authPage: AuthPage.onTypingPasswordPage,
        authType: state!.authType,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: USE BLOC BUILDER
    state = authBloc.state as AuthStateTypingEmail;

    return GenericButton(
      backgroundColor: state!.isFieldValid
          ? null
          : MaterialStateProperty.all(
              const Color.fromRGBO(250, 250, 250, 100),
            ),
      onPressed: state!.isFieldValid ? proceed : null,
      child: GenericChild(
        button: state!.isFieldValid ? Button.nextEnabled : Button.nextDisabled,
      ),
    );
  }
}
