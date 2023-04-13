import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';

import 'package:pdf_editor/auth/views/login/login_type_email_view.dart';

import 'package:pdf_editor/auth/views/main_auth/main_auth_view.dart';
import 'package:pdf_editor/bloc/app_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';
import 'package:pdf_editor/viewer/views/pdf_viewer.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';
import 'auth/views/login/login_type_password_view.dart';
import 'auth/views/register/register_type_email_view.dart';
import 'auth/views/register/register_type_password_view.dart';
import 'bloc/app_states.dart';

import 'package:stack_trace/stack_trace.dart' as stack_trace;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
  runApp(const ProviderScope(child: PdfReader()));
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
        home: PdfViewer(),
      ),
    );
  }
}

class PdfReader extends StatelessWidget {
  const PdfReader({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(routes: {
      "pdf_viewer": (context) => PdfViewer(),
      "/auth/main_auth/": (context) => const MainAuthView(),
      '/auth/login/password/': (context) => const LoginTypePasswordView(),
      '/auth/login/email/': (context) => const LoginTypeEmailView(),
      '/auth/register/password/': (context) => const RegisterTypePasswordView(),
      '/auth/register/email/': (context) => const RegisterTypeEmailView(),
    }, debugShowCheckedModeBanner: false, home: const AppNavigator());
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    FilePicker.platform
        .pickFiles(type: FileType.any)
        .then((value) => print(value));
    return BlocProvider(
      create: (context) => AppBloc(),
      child: Builder(
        builder: (context) {
          final appBloc = context.read<AppBloc>()
            ..add(
              const AppEventDisplayPdfViewer(
                '/data/user/0/com.example.pdf_editor/cache/file_picker/The-Selfish-Gene-R.-Dawkins-1976-WW-.pdf',
              ),
            );
          return BlocListener<AppBloc, AppState>(
            listener: (context, state) async {
              if (state is AppStateDisplayingPdfViewer) {
                await Navigator.of(context).pushNamedAndRemoveUntil(
                    "pdf_viewer", (route) => false,
                    arguments: appBloc.pdfToImageConverter!);
              }
            },
            child: const CircularProgressIndicator(),
          );
        },
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
