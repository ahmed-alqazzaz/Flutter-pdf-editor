import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_page.dart';
import 'package:pdf_editor/auth/bloc/enums/auth_type.dart';
import 'package:pdf_editor/auth/generics/generic_auth_view/generic_auth_view.dart';
import 'package:pdf_editor/auth/views/login/login_type_email_view.dart';

import 'package:pdf_editor/auth/views/main_auth/main_auth_view.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';
import 'auth/views/login/login_type_password_view.dart';
import 'auth/views/register/register_type_email_view.dart';
import 'auth/views/register/register_type_password_view.dart';

void main() {
  runApp(const PDFEditor());
}

class PDFEditor extends StatefulWidget {
  const PDFEditor({super.key});

  @override
  State<PDFEditor> createState() => _PdfEditorState();
}

class _PdfEditorState extends State<PDFEditor> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(_navigatorKey),
      child: MaterialApp(
        navigatorKey: _navigatorKey,
        routes: {
          "/auth/main_auth/": (context) => const MainAuthView(),
          '/auth/login/password/': (context) => const LoginTypePasswordView(),
          '/auth/login/email/': (context) => const LoginTypeEmailView(),
          '/auth/register/password/': (context) =>
              const RegisterTypePasswordView(),
          '/auth/register/email/': (context) => const RegisterTypeEmailView(),
        },
        debugShowCheckedModeBanner: false,
        home: const PageNavigator(),
      ),
    );
  }
}

class PageNavigator extends StatelessWidget {
  const PageNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    context
        .read<AuthBloc>()
        .add(const AuthEventSeekMain(shouldSkipButtonGlow: false));
    return BlocListener<AuthBloc, AuthState>(
      child: const CircularProgressIndicator(),
      listener: (context, state) {
        if (state is AuthStateMain) {
          // Navigator.of(context)
          //     .pushNamedAndRemoveUntil('/auth/main_auth/', (route) => false);
        }
      },
    );
  }
}
