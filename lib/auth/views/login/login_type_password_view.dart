import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../generics/buttons/generic_button.dart';
import '../../generics/buttons/generic_child.dart';
import '../../generics/buttons/enums/button.dart';

typedef OnNext = void Function();

class GenericTypePasswordView extends StatefulWidget {
  const GenericTypePasswordView({super.key});

  @override
  State<GenericTypePasswordView> createState() => _GenericTypeEmailViewState();
}

class _GenericTypeEmailViewState extends State<GenericTypePasswordView> {
  AuthBloc? authBloc;
  bool _isPasswordValid = false;
  bool _shouldVisibilityIconShimmer = false;
  bool _isTextObscure = false;
  Timer? _timer;
  Color _textFieldBorderColor = const Color.fromRGBO(186, 186, 186, 100);

  late final String headerText;
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void didChangeDependencies() {
    authBloc = context.read<AuthBloc>();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    headerText = 'Create account';

    _focusNode = FocusNode();
    _controller = TextEditingController();
    _controller.addListener(() {
      //check if email is valid
      String text = _controller.text.toLowerCase();

      _isPasswordValid = text.length > 7;

      try {
        if (text.isNotEmpty && _isPasswordValid == false) {
          authBloc?.add(
            AuthEventTypePassword(
              shouldVisibilityIconShimmer: _shouldVisibilityIconShimmer,
              isTextObscure: _isTextObscure,
              textFieldBorderColor: Colors.deepPurple,
              authType: AuthType.login,
              isFieldValid: _isPasswordValid,
            ),
          );
        } else if (text.isEmpty && _isPasswordValid == false) {
          authBloc?.add(
            AuthEventTypePassword(
              shouldVisibilityIconShimmer: _shouldVisibilityIconShimmer,
              isTextObscure: _isTextObscure,
              textFieldBorderColor: const Color.fromRGBO(186, 186, 186, 100),
              authType: AuthType.login,
              isFieldValid: _isPasswordValid,
            ),
          );
        } else if (text.isNotEmpty && _isPasswordValid == true) {
          authBloc?.add(
            AuthEventTypePassword(
              shouldVisibilityIconShimmer: _shouldVisibilityIconShimmer,
              isTextObscure: _isTextObscure,
              textFieldBorderColor: Colors.green,
              authType: AuthType.login,
              isFieldValid: _isPasswordValid,
            ),
          );
        }
      } catch (e) {
        print(e);
      }
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
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previousState, currentState) {
        if (currentState is AuthStateTypingPassword &&
            currentState.authType == AuthType.login &&
            previousState is AuthStateTypingPassword &&
            previousState.authType == AuthType.login) {
          // in case the user type a valid email then deletes it
          if (currentState.isFieldValid == false &&
              previousState.isFieldValid == true) {
            setState(() {
              _textFieldBorderColor = Colors.red;
            });

            return false;
          }
        }
        return true;
      },
      listener: (context, state) {
        if (state is AuthStateTypingPassword &&
            state.authType == AuthType.login) {
          // in case the user type valid email then deletes it
          setState(() {
            _isTextObscure = state.isTextObscure;
            _shouldVisibilityIconShimmer = state.shouldVisibilityIconShimmer;
            _textFieldBorderColor = state.textFieldBorderColor;
            _isPasswordValid = state.isFieldValid;
          });
        }
      },
      child: WillPopScope(
        child: LayoutBuilder(
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
                          style: ButtonStyle(
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                          onPressed: () {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _focusNode.unfocus();
                            });
                            // TODO: consider increasing the duration of the navigator animation instead of waiting
                            //wait for keyboard to go down
                            Future.delayed(const Duration(milliseconds: 200))
                                .then(
                              (value) {
                                context.read<AuthBloc>().add(
                                    const AuthEventSeekMain(
                                        shouldSkipButtonGlow: false));
                              },
                            );
                          },
                          child: const Icon(
                            Icons.arrow_back_outlined,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomCenter,
                        width: constraints.maxWidth * 0.6,
                        child: Text(
                          headerText,
                          style: const TextStyle(
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
                            "Enter your password",
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
                          decoration: InputDecoration(
                            suffixIcon: Shimmer.fromColors(
                              enabled: _shouldVisibilityIconShimmer,
                              period: const Duration(milliseconds: 1500),
                              baseColor: Colors.black,
                              highlightColor: Colors.grey[100]!,
                              child: GestureDetector(
                                onTapUp: (details) {
                                  //cancel the shimmer disabling if exists
                                  _timer?.cancel();
                                  context.read<AuthBloc>().add(
                                        AuthEventTypePassword(
                                          shouldVisibilityIconShimmer: true,
                                          isTextObscure: !_isTextObscure,
                                          textFieldBorderColor:
                                              _textFieldBorderColor,
                                          authType: AuthType.login,
                                          isFieldValid: _isPasswordValid,
                                        ),
                                      );

                                  //disable the shimmer after one 4.5 seconds
                                  _timer = Timer(
                                    const Duration(milliseconds: 4500),
                                    () {
                                      context.read<AuthBloc>().add(
                                            AuthEventTypePassword(
                                              shouldVisibilityIconShimmer:
                                                  false,
                                              isTextObscure: !_isTextObscure,
                                              textFieldBorderColor:
                                                  _textFieldBorderColor,
                                              authType: AuthType.login,
                                              isFieldValid: _isPasswordValid,
                                            ),
                                          );
                                    },
                                  );
                                },
                                child: Container(
                                  alignment: const Alignment(1, 0.5),
                                  width: 1,
                                  child: Icon(
                                    _isTextObscure
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 7),
                            prefixIcon: Container(
                              alignment: const Alignment(-1, 0.5),
                              width: 1,
                              child: const Image(
                                image: AssetImage("assets/email_logo.png"),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: _textFieldBorderColor,
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: true,
                          autofocus: false,
                          obscureText: _isTextObscure,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GenericButton(
                          backgroundColor: _isPasswordValid
                              ? MaterialStateProperty.all(
                                  Colors.deepPurple,
                                )
                              : MaterialStateProperty.all(
                                  const Color.fromRGBO(186, 186, 186, 1)),
                          onPressed: _isPasswordValid ? () {} : null,
                          child: const GenericChild(
                            button: Button.login,
                          ))
                    ]),
                  ),
                ],
              ),
            );
          },
        ),
        onWillPop: () async {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _focusNode.unfocus();
          });
          Future.delayed(const Duration(milliseconds: 100)).then(
            (value) {
              context
                  .read<AuthBloc>()
                  .add(const AuthEventSeekMain(shouldSkipButtonGlow: false));
            },
          );
          return false;
        },
      ),
    );
  }
}
