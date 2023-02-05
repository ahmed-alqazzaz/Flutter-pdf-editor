import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';
import 'package:pdf_editor/auth/bloc/auth_state.dart';
import 'package:pdf_editor/auth/bloc/enums/current_login_page.dart';

import '../main_auth/buttons/generic_button.dart';
import '../main_auth/buttons/generic_child.dart';
import '../main_auth/enums/button.dart';

class LoginEmailView extends StatefulWidget {
  const LoginEmailView({super.key});

  @override
  State<LoginEmailView> createState() => _LoginEmailViewState();
}

class _LoginEmailViewState extends State<LoginEmailView> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late bool isEmailValid;
  AuthBloc? authBloc;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    authBloc = context.read<AuthBloc>();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _controller.addListener(() {
      //check if email is valid
      String text = _controller.text.toLowerCase();
      isEmailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(text);
      authBloc?.add(
        AuthEventSeekLogin(
          currentLoginPage: CurrentLoginPage.email,
          isFieldValid: isEmailValid,
        ),
      );
    });

    // when directly making the textfield auto focus, overflow error occurs
    // this errors occurs because the keyboard will be displayed in the previous page during th navigation
    // the following ensures that the transition is over then enables autofocus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        _focusNode.requestFocus();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.select((AuthBloc bloc) => bloc.state);
    if (state is AuthStateLoggingIn &&
        state.currentLoginPage == CurrentLoginPage.email) {
      isEmailValid = state.isFieldValid;
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Column(
            children: [
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.bottomLeft,
                    width: constraints.maxWidth * 0.2,
                    child: TextButton(
                      onPressed: () {},
                      child: const Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    width: constraints.maxWidth * 0.6,
                    child: const Text(
                      "Create account",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: constraints.maxWidth * 0.2,
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: constraints.maxWidth * 0.04),
                child: Column(children: [
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: const [
                      Text(
                        "Enter your email",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: TextField(
                      focusNode: _focusNode,
                      controller: _controller,
                      textAlignVertical: const TextAlignVertical(y: 1),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 7),
                        prefixIcon: Image(
                          alignment: Alignment(-0.5, 0.5),
                          image: AssetImage("assets/email_logo.png"),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 31, 94, 203),
                            width: 2,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      autocorrect: true,
                      autofocus: false,
                    ),
                  ),
                  const SizedBox(height: 30),
                  GenericButton(
                      backgroundColor: isEmailValid
                          ? null
                          : MaterialStateProperty.all(
                              Color.fromARGB(26, 123, 123, 123),
                            ),
                      onPressed: () {},
                      child: GenericChild(
                        button: isEmailValid
                            ? Button.nextEnabled
                            : Button.nextDisabled,
                      ))
                ]),
              ),
            ],
          ),
        );
      },
    );
  }
}
