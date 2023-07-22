import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemmatizerx/lemmatizerx.dart';
import 'package:pdf_editor/auth/auth_service/auth_service.dart';

import 'package:pdf_editor/auth/views/main_auth/main_auth_view.dart';
import 'package:pdf_editor/bloc/app_bloc.dart';
import 'package:pdf_editor/homepage/views/homepage_view.dart';
import 'package:pdf_editor/pdf_renderer/rust_pdf_renderer/rust_pdf_renderer.dart';
import 'package:pdf_editor/viewer/providers/pdf_viewer_related/scroll_controller_provider.dart';
import 'package:pdf_editor/viewer/views/pdf_viewer.dart';

import 'auth/bloc/auth_bloc.dart';
import 'bloc/app_states.dart';

import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'helpers/loading/loading_screen.dart';
import 'homepage/bloc/home_bloc.dart';

Future<void> main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await RustPdfRenderer.instance().initialize();
  await AuthService().initialize();

  Lemmatizer().lemmasOnly("initialize");
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(const ProviderScope(child: PdfReader()));
}

class PdfReader extends StatelessWidget {
  const PdfReader({super.key});
  static const iconsTheme = IconThemeData(
    color: Color.fromARGB(200, 33, 33, 33),
  );
  static const appBarTheme = AppBarTheme(
    color: Colors.white,
    shadowColor: Color.fromARGB(100, 228, 228, 228),
    elevation: 3,
    iconTheme: iconsTheme,
  );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: MaterialApp(
        theme: ThemeData(appBarTheme: appBarTheme, iconTheme: iconsTheme),
        debugShowCheckedModeBanner: false,
        navigatorObservers: [
          RouteObserver<PageRoute<dynamic>>(),
        ],
        home: const AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  Future<void> _navigateTo(
      {required BuildContext context, required MaterialPageRoute route}) async {
    final navigator = Navigator.of(context);
    navigator.canPop()
        ? await navigator.pushReplacement(route)
        : await navigator.push(route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppBloc, AppState>(
      listenWhen: (previous, current) {
        if (previous is AppStateInitial && current is! AppStateInitial) {
          FlutterNativeSplash.remove();
        }
        return true;
      },
      listener: (context, state) {
        LoadingScreen().hide();
        if (state is AppStateNeedsAuthentication) {
          _navigateTo(
            context: context,
            route: MaterialPageRoute<MainAuthView>(
              builder: (_) {
                return BlocProvider<AppBloc>.value(
                  value: BlocProvider.of<AppBloc>(context),
                  child: BlocProvider(
                    create: (context) => AuthBloc(),
                    child: const MainAuthView(),
                  ),
                );
              },
            ),
          );
        }
        if (state is AppStateDisplayingPdfViewer && state.isLoading) {
          _navigateTo(
            context: context,
            route: MaterialPageRoute<PdfViewer>(
              builder: (_) => BlocProvider<AppBloc>.value(
                value: BlocProvider.of<AppBloc>(context),
                child: ProviderScope(
                  overrides: [
                    scrollControllerProvider.overrideWith(
                      (ref) => ScrollControllerModel(),
                    )
                  ],
                  child: const PdfViewer(),
                ),
              ),
            ),
          );
        }

        if (state is AppStateDisplayingHomePage) {
          _navigateTo(
            context: context,
            route: MaterialPageRoute<HomePageView>(
              builder: (_) {
                return BlocProvider(
                  create: (context) => HomePageBloc(state.pdfFilesManager),
                  child: BlocProvider<AppBloc>.value(
                    value: BlocProvider.of<AppBloc>(context),
                    child: const HomePageView(),
                  ),
                );
              },
            ),
          );
        }
      },
      child: Builder(builder: (context) {
        return const CircularProgressIndicator();
      }),
    );
  }
}
