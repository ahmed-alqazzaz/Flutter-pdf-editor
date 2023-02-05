import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdf_editor/auth/services/auth/firebase_auth_provider.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_state.dart';
import 'buttons/generic_button.dart';
import 'buttons/generic_child.dart';
import 'enums/button.dart';

class MainAuthView extends StatefulWidget {
  const MainAuthView({super.key});

  @override
  State<MainAuthView> createState() => _MainAuthViewState();
}

class _MainAuthViewState extends State<MainAuthView> {
  late List<Shadow>? skipButtonShadows;
  late Color skipButtonColor;

  @override
  Widget build(BuildContext context) {
    final currentState = context.select((AuthBloc bloc) => bloc.state);
    if (currentState is AuthStateMain) {
      if (currentState.shouldSkipButtonGlow == true) {
        skipButtonShadows = const [
          Shadow(
            color: Colors.black,
            blurRadius: 15.0,
            offset: Offset(4.0, 4.0),
          ),
        ];
        skipButtonColor = Colors.black;
      } else {
        skipButtonShadows = null;
        skipButtonColor = const Color.fromARGB(255, 115, 112, 112);
      }
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(height: constraints.minHeight * 0.22),
              GenericButton(
                onPressed: () async {
                  await FirebaseAuthProvider().signInWithFacebook();
                },
                child: const GenericChild(
                  button: Button.facebook,
                ),
              ),
              GenericButton(
                onPressed: () async {
                  await FirebaseAuthProvider().signInWithGoogle();
                },
                child: const GenericChild(
                  button: Button.google,
                ),
              ),
              GenericButton(
                onPressed: () {},
                child: const GenericChild(
                  button: Button.apple,
                ),
              ),
              SizedBox(height: constraints.maxHeight * 0.04),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: constraints.maxWidth * 0.04),
                  const Expanded(
                    child: Divider(
                      height: 2.0,
                      color: Color.fromARGB(255, 115, 112, 112),
                      thickness: 0.8,
                    ),
                  ),
                  SizedBox(width: constraints.maxWidth * 0.02),
                  const Text(
                    "or",
                    style: TextStyle(
                        color: Color.fromARGB(255, 99, 95, 95),
                        fontSize: 18,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(width: constraints.maxWidth * 0.02),
                  const Expanded(
                    child: Divider(
                      height: 2.0,
                      color: Color.fromARGB(255, 126, 122, 122),
                      thickness: 0.8,
                    ),
                  ),
                  SizedBox(width: constraints.maxWidth * 0.04),
                ],
              ),
              SizedBox(height: constraints.maxHeight * 0.04),
              GenericButton(
                backgroundColor: MaterialStateProperty.all(
                  Colors.deepPurple,
                ),
                onPressed: () async {
                  await FirebaseAuthProvider().initialize();
                },
                child: const GenericChild(
                  button: Button.login,
                ),
              ),
              GenericButton(
                onPressed: () {},
                child: const GenericChild(
                  button: Button.createAccount,
                ),
              ),
              SizedBox(height: constraints.minHeight * 0.13),
              GestureDetector(
                onTapDown: (details) {
                  context
                      .read<AuthBloc>()
                      .add(const AuthEventSeekMain(shouldSkipButtonGlow: true));
                },
                onTapUp: (details) {
                  context.read<AuthBloc>().add(
                      const AuthEventSeekMain(shouldSkipButtonGlow: false));
                },
                onTapCancel: () {
                  context.read<AuthBloc>().add(
                      const AuthEventSeekMain(shouldSkipButtonGlow: false));
                },
                child: Text(
                  "Skip for now",
                  style: TextStyle(
                    shadows: skipButtonShadows,
                    color: skipButtonColor,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        );
      },
    );
  }
}