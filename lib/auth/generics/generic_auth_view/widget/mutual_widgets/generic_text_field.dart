import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_state.dart';

class GenericTextField extends StatefulWidget {
  const GenericTextField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.suffixIcon,
    required this.prefixIcon,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Widget? suffixIcon;
  final Widget prefixIcon;
  @override
  State<GenericTextField> createState() => _GenericTextFieldState();
}

class _GenericTextFieldState extends State<GenericTextField> {
  late final AuthBloc authBloc;
  @override
  void didChangeDependencies() {
    authBloc = context.read<AuthBloc>();

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // this does'nt work on some old devices because the the textfield widget might not be fully disposed when clicking the back button while the state will change to authstatemain resulting in cast error
    final state = authBloc.state as AuthStateTypingEmailOrPassword;
    return TextField(
      focusNode: widget.focusNode,
      controller: widget.controller,
      textAlignVertical: const TextAlignVertical(y: 1),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 7),
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.prefixIcon,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: state.textFieldBorderColor,
            width: 2,
          ),
        ),
      ),
      keyboardType: state is AuthStateTypingPassword
          ? state.isTextObscure == false
              ? TextInputType.visiblePassword
              : null
          : TextInputType.emailAddress,
      autocorrect: true,
      autofocus: false,
      obscureText:
          state is AuthStateTypingPassword ? state.isTextObscure : false,
    );
  }
}
