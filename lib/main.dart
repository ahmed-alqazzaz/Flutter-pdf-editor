import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';

import 'package:pdf_editor/auth/views/main_auth/main_auth_view.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';

void main() {
  runApp(const PDFEditor());
}

class PDFEditor extends StatefulWidget {
  const PDFEditor({super.key});

  @override
  State<PDFEditor> createState() => _PdfEditorState();
}

class _PdfEditorState extends State<PDFEditor> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: PageNavigator(),
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
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const MainAuthView()),
              (route) => false);
        }
      },
    );
  }
}
