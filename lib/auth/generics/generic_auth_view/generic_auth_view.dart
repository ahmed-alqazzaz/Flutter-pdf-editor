import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pdf_editor/auth/generics/generic_auth_view/widget/mutual_widgets/generic_auth_page_header.dart';
import 'package:pdf_editor/auth/generics/generic_auth_view/widget/mutual_widgets/generic_prefix_icon.dart';
import 'package:pdf_editor/auth/generics/generic_auth_view/widget/mutual_widgets/generic_text_field.dart';
import 'package:pdf_editor/auth/generics/generic_auth_view/widget/mutual_widgets/generic_textfield_header.dart';

import 'package:pdf_editor/auth/generics/generic_auth_view/widget/type_email_widgets/proceed_button.dart';
import 'package:pdf_editor/auth/generics/generic_auth_view/widget/type_password_widgets/proceed_button.dart';
import 'package:pdf_editor/auth/generics/generic_auth_view/widget/type_password_widgets/suffix_icon.dart';
import 'package:pdf_editor/helpers/error_messages/show_error_message.dart';
import 'package:pdf_editor/helpers/loading/loading_screen.dart';

import '../../bloc/auth_bloc.dart';
import '../../bloc/auth_event.dart';
import '../../bloc/auth_state.dart';

class GenericAuthView extends StatefulWidget {
  const GenericAuthView({
    super.key,
    required this.onProceed,
    required this.onBack,
  });

  final OnPressed onBack;
  final OnPressed onProceed;

  @override
  State<GenericAuthView> createState() => _GenericTypeEmailViewState();
}

class _GenericTypeEmailViewState extends State<GenericAuthView> {
  late final AuthBloc authBloc;

  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  final timerStreamController = StreamController<Timer?>.broadcast();
  late Timer? timer;

  @override
  void didChangeDependencies() {
    authBloc = context.read<AuthBloc>();

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void textFieldListener() {
    //check if field is valid
    final String text = _controller.text.toLowerCase();

    final state = authBloc.state as AuthStateTypingEmailOrPassword;

    if (state is AuthStateTypingEmail) {
      final isFieldValid = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(text);

      // in case textfield is empty, the color is grey
      // is case it's not empty and the field is valid(legit email for example), the color is green
      // in case it's not empty and the field is invalid, the color is purple
      authBloc.add(
        AuthEventTypeEmail(
          textFieldBorderColor: text.isEmpty
              ? const Color.fromRGBO(186, 186, 186, 100)
              : isFieldValid
                  ? Colors.green
                  : state.textFieldBorderColor == Colors.red
                      ? Colors.red
                      : Colors.deepPurple,
          authPage: state.authPage,
          isFieldValid: isFieldValid,
          authType: state.authType,
        ),
      );
    } else if (state is AuthStateTypingPassword) {
      // the password is valid if it's longer than 6 characters
      final isFieldValid = text.length > 6;

      authBloc.add(
        AuthEventTypePassword(
          email: state.email,
          textFieldBorderColor: text.isEmpty
              ? const Color.fromRGBO(186, 186, 186, 100)
              : isFieldValid
                  ? Colors.green
                  : state.textFieldBorderColor == Colors.red
                      ? Colors.red
                      : Colors.deepPurple,
          shouldVisibilityIconShimmer: state.shouldVisibilityIconShimmer,
          isTextObscure: state.isTextObscure,
          authPage: state.authPage,
          isFieldValid: isFieldValid,
          authType: state.authType,
        ),
      );
    }
  }

  @override
  void initState() {
    timerStreamController.sink.add(null);
    // when directly making the textfield auto focus, overflow error occurs
    // this error occurs because the keyboard will be displayed in the previous page during the navigation
    // the following ensures that the transition is over and the authbloc is defined then enables autofocus
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300)).then((value) {
        _focusNode.requestFocus();
      });
    });

    _controller = TextEditingController();

    _focusNode = FocusNode();

    _controller.addListener(textFieldListener);
    timerStreamController.stream.listen((event) {
      timer = event;
    });
    timerStreamController.sink.add(null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previousState, currentState) {
        if (currentState is AuthStateTypingEmailOrPassword &&
            currentState.authPage == currentState.authPage &&
            previousState is AuthStateTypingEmailOrPassword &&
            previousState.authPage == currentState.authPage) {
          // in case the user type a valid email then deletes it
          if (currentState.isFieldValid == false &&
              previousState.isFieldValid == true) {
            if (currentState is AuthStateTypingEmail) {
              authBloc.add(AuthEventTypeEmail(
                authType: currentState.authType,
                authPage: currentState.authPage,
                isFieldValid: currentState.isFieldValid,
                textFieldBorderColor: Colors.red,
              ));
            }
          }
        }
        return true;
      },
      listener: (context, state) {
        if (state is AuthStateTypingPassword) {
          if (state.isLoading == true) {
            LoadingScreen().show(context: context, text: "Signing in...");
          } else {
            LoadingScreen().hide();
          }

          if (state.exception != null) {
            // TODO: custom error messages
            showErrorMessage(
              context: context,
              text: "something went wrong",
              duration: const Duration(seconds: 3),
            );
          }
        }
      },
      buildWhen: (previous, currentState) {
        if (currentState is AuthStateTypingEmailOrPassword &&
            currentState.authPage == currentState.authPage) {
          return true;
        }
        return false;
      },
      builder: (context, state) {
        state as AuthStateTypingEmailOrPassword;

        return WillPopScope(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Scaffold(
                body: Column(
                  children: [
                    const SizedBox(height: 30),
                    GenericAuthPageHeader(
                      onBackButtonPressed: () {
                        widget.onBack();
                      },
                      authType: state.authType,
                      constraints: constraints,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: constraints.maxWidth * 0.04),
                      child: Column(
                        children: [
                          const SizedBox(height: 50),
                          GenericTextFieldHeader(state: state),
                          // Textfield
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: GenericTextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              suffixIcon: state is AuthStateTypingPassword
                                  ? SuffixIcon(
                                      timerStreamController:
                                          timerStreamController)
                                  : null,
                              prefixIcon: const GenericPrefixIcon(),
                            ),
                          ),
                          const SizedBox(height: 20),

                          if (state is AuthStateTypingEmail) ...[
                            TypeEmailProceedButton(
                              textFieldListener: textFieldListener,
                              controller: _controller,
                            ),
                          ] else if (state is AuthStateTypingPassword) ...[
                            TypePasswordProceedButtonn(
                              focusNode: _focusNode,
                              controller: _controller,
                            )
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          onWillPop: () async {
            // the future reponsible for disabling the shimmer might still be running in the background
            // this future results in emitting AuthStateTypingPassword
            // if this state is emitted after the current view is disposed after the back button is clicked, the app will naviagte back to the typing password view
            // so we should cancel it if it exists
            timer?.cancel();

            widget.onBack();

            return false;
          },
        );
      },
    );
  }
}
