import 'package:flutter/material.dart';

import 'package:pdf_editor/services/auth/firebase_auth_provider.dart';

import 'buttons/generic_button.dart';
import 'buttons/generic_child.dart';
import 'enums/button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuthProvider().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 180),
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
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(width: 20),
                      Expanded(
                        child: Divider(
                          height: 2.0,
                          color: Color.fromARGB(255, 115, 112, 112),
                          thickness: 0.8,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "or",
                        style: TextStyle(
                            color: Color.fromARGB(255, 99, 95, 95),
                            fontSize: 18,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Divider(
                          height: 2.0,
                          color: Color.fromARGB(255, 126, 122, 122),
                          thickness: 0.8,
                        ),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  const SizedBox(height: 30),
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
                ],
              ),
            );

          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
