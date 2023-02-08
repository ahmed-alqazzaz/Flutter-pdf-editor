import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import 'package:pdf_editor/auth/generics/views/type_email_widgets/proceed_button.dart';
import 'package:pdf_editor/auth/generics/views/type_password_widgets/proceed_button.dart';
import 'package:shimmer/shimmer.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

typedef OnProceed = void Function();

class GenericAuthView extends StatefulWidget {
  const GenericAuthView({
    super.key,
    required this.authPage,
    required this.onProceed,
    required this.authType,
  });

  final AuthPage authPage;
  final AuthType authType;

  final OnProceed onProceed;

  @override
  State<GenericAuthView> createState() => _GenericTypeEmailViewState();
}

class _GenericTypeEmailViewState extends State<GenericAuthView> {
  late final AuthBloc authBloc;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  late bool _isFieldValid;
  late bool _isTextObscure;
  late bool _shouldVisibilityIconShimmer;
  late Color _textFieldBorderColor;
  Timer? _timer;

  @override
  void didChangeDependencies() {
    authBloc = context.read<AuthBloc>();
    final state = authBloc.state;
    if (state is AuthStateTypingEmail) {
      _isFieldValid = state.isFieldValid;
      _textFieldBorderColor = state.textFieldBorderColor;

      //asignning textfield related widgets

    } else if (state is AuthStateTypingPassword) {
      _isFieldValid = state.isFieldValid;
      _textFieldBorderColor = state.textFieldBorderColor;
      _shouldVisibilityIconShimmer = state.shouldVisibilityIconShimmer;
      _isTextObscure = state.isTextObscure;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // when directly making the textfield auto focus, overflow error occurs
    // this error occurs because the keyboard will be displayed in the previous page during the navigation
    // the following ensures that the transition is over and the authbloc is defined then enables autofocus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        _focusNode.requestFocus();
      });
    });

    _focusNode = FocusNode();
    _controller = TextEditingController();
    _controller.addListener(
      () {
        //check if field is valid
        String text = _controller.text.toLowerCase();

        if (authBloc.state is AuthStateTypingEmail) {
          _isFieldValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(text);
          // in case textfield is empty, the color is grey
          // is case it's not empty and the field is valid(legit email for example), the color is green
          // in case it's not empty and the field is invalid, the color is purple
          authBloc.add(
            AuthEventTypeEmail(
              textFieldBorderColor: text.isEmpty
                  ? const Color.fromRGBO(186, 186, 186, 100)
                  : _isFieldValid
                      ? Colors.green
                      : Colors.deepPurple,
              authPage: widget.authPage,
              isFieldValid: _isFieldValid,
              authType: widget.authType,
            ),
          );
        } else if (authBloc.state is AuthStateTypingPassword) {
          // the password is valid if it's longer than 6 characters
          _isFieldValid = text.length > 6;
          authBloc.add(
            AuthEventTypePassword(
              textFieldBorderColor: text.isEmpty
                  ? const Color.fromRGBO(186, 186, 186, 100)
                  : _isFieldValid
                      ? Colors.green
                      : Colors.deepPurple,
              shouldVisibilityIconShimmer: _shouldVisibilityIconShimmer,
              isTextObscure: _isTextObscure,
              authPage: widget.authPage,
              isFieldValid: _isFieldValid,
              authType: widget.authType,
            ),
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previousState, currentState) {
        if (currentState is AuthStateTypingEmailOrPassword &&
            currentState.authPage == widget.authPage &&
            previousState is AuthStateTypingEmailOrPassword &&
            previousState.authPage == widget.authPage) {
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
        if (state is AuthStateTypingEmailOrPassword &&
            state.authPage == widget.authPage) {
          setState(() {
            _textFieldBorderColor = state.textFieldBorderColor;
            _isFieldValid = state.isFieldValid;
          });

          if (state is AuthStateTypingPassword) {
            setState(() {
              _isTextObscure = state.isTextObscure;
              _shouldVisibilityIconShimmer = state.shouldVisibilityIconShimmer;
            });
          }
        }
      },
      buildWhen: (previous, currentState) {
        if (currentState is AuthStateTypingEmailOrPassword &&
            currentState.authPage == widget.authPage) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        return WillPopScope(
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
                            widget.authType == AuthType.login
                                ? "Log in"
                                : "Create Account",
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
                          children: [
                            Text(
                              state is AuthStateTypingEmail
                                  ? "Enter your email"
                                  : "Now your email",
                              style: const TextStyle(
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
                              contentPadding:
                                  const EdgeInsets.symmetric(vertical: 7),
                              // in case state is typing email don't display suffix icon
                              suffixIcon: state is AuthStateTypingEmail
                                  ? null
                                  : Shimmer.fromColors(
                                      enabled: _shouldVisibilityIconShimmer,
                                      period:
                                          const Duration(milliseconds: 1500),
                                      baseColor: Colors.black,
                                      // in case there is residual shimmer left when shimmer is disabled, turn it's color to black
                                      highlightColor:
                                          _shouldVisibilityIconShimmer
                                              ? Colors.grey[100]!
                                              : Colors.black,
                                      child: GestureDetector(
                                        onTapUp: (details) {
                                          //cancel the shimmer disabling if exists
                                          _timer?.cancel();
                                          context.read<AuthBloc>().add(
                                                AuthEventTypePassword(
                                                  shouldVisibilityIconShimmer:
                                                      true,
                                                  isTextObscure:
                                                      !_isTextObscure,
                                                  textFieldBorderColor:
                                                      _textFieldBorderColor,
                                                  authPage: widget.authPage,
                                                  isFieldValid: _isFieldValid,
                                                  authType: widget.authType,
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
                                                      isTextObscure:
                                                          !_isTextObscure,
                                                      textFieldBorderColor:
                                                          _textFieldBorderColor,
                                                      authPage: widget.authPage,
                                                      isFieldValid:
                                                          _isFieldValid,
                                                      authType: widget.authType,
                                                    ),
                                                  );
                                            },
                                          );
                                        },
                                        child: Container(
                                          alignment: const Alignment(1, 0.5),
                                          width: 1,
                                          child: Icon(
                                            size: 20,
                                            _isTextObscure
                                                ? Icons.visibility_off_outlined
                                                : Icons.visibility_outlined,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                              prefixIcon: Container(
                                alignment: const Alignment(-1, 0.5),
                                width: 1,
                                child: Icon(
                                  size: 20,
                                  color: Colors.black,
                                  state is AuthStateTypingEmail
                                      ? Icons.email_outlined
                                      : Icons.lock_outline_sharp,
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
                          ),
                        ),
                        const SizedBox(height: 20),
                        if (state is AuthStateTypingEmail) ...[
                          TypeEmailProceedButton(
                            onProceed: widget.onProceed,
                            isFieldValid: _isFieldValid,
                          ),
                        ] else if (state is AuthStateTypingPassword) ...[
                          TypePasswordProceedButton(
                            onProceed: widget.onProceed,
                            isFieldValid: _isFieldValid,
                          )
                        ]
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
        );
      },
    );
  }
}
