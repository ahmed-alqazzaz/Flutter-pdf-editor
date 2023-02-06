import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';
import '../../views/main_auth/enums/button.dart';
import '../buttons/generic_button.dart';
import '../buttons/generic_child.dart';

typedef OnNext = void Function();

class GenericTypeEmailView extends StatefulWidget {
  final OnNext onNext;
  final AuthType authType;

  const GenericTypeEmailView(
      {super.key, required this.authType, required this.onNext});

  @override
  State<GenericTypeEmailView> createState() => _GenericTypeEmailViewState();
}

class _GenericTypeEmailViewState extends State<GenericTypeEmailView> {
  AuthBloc? authBloc;
  bool _isEmailValid = false;
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
    if (widget.authType == AuthType.register) {
      headerText = 'Create account';
    } else {
      headerText = 'Log in';
    }
    _focusNode = FocusNode();
    _controller = TextEditingController();
    _controller.addListener(() {
      //check if email is valid
      String text = _controller.text.toLowerCase();

      _isEmailValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(text);

      try {
        if (text.isNotEmpty && _isEmailValid == false) {
          authBloc?.add(
            AuthEventTypeEmail(
              textFieldBorderColor: const Color.fromARGB(255, 31, 94, 203),
              authType: widget.authType,
              isFieldValid: _isEmailValid,
            ),
          );
        } else if (text.isEmpty && _isEmailValid == false) {
          authBloc?.add(
            AuthEventTypeEmail(
              textFieldBorderColor: const Color.fromRGBO(186, 186, 186, 100),
              authType: widget.authType,
              isFieldValid: _isEmailValid,
            ),
          );
        } else if (text.isNotEmpty && _isEmailValid == true) {
          authBloc?.add(
            AuthEventTypeEmail(
              textFieldBorderColor: Colors.green,
              authType: widget.authType,
              isFieldValid: _isEmailValid,
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
        if (currentState is AuthStateTypingEmail &&
            currentState.authType == widget.authType &&
            previousState is AuthStateTypingEmail &&
            previousState.authType == widget.authType) {
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
        if (state is AuthStateTypingEmail &&
            state.authType == widget.authType) {
          // in case the user type valid email then deletes it
          setState(() {
            _textFieldBorderColor = state.textFieldBorderColor;
            _isEmailValid = state.isFieldValid;
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
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 7),
                            prefixIcon: const Image(
                              alignment: Alignment(-0.5, 0.5),
                              image: AssetImage("assets/email_logo.png"),
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
                      GenericButton(
                          backgroundColor: _isEmailValid
                              ? null
                              : MaterialStateProperty.all(
                                  const Color.fromRGBO(250, 250, 250, 100),
                                ),
                          onPressed: _isEmailValid ? widget.onNext : null,
                          child: GenericChild(
                            button: _isEmailValid
                                ? Button.nextEnabled
                                : Button.nextDisabled,
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
