import 'dart:async';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lemmatizerx/lemmatizerx.dart';
import 'package:pdf_editor/auth/auth_route.dart';
import 'package:pdf_editor/auth/auth_service/auth_service.dart';
import 'package:pdf_editor/auth/bloc/auth_event.dart';

import 'package:pdf_editor/auth/views/login/login_type_email_view.dart';

import 'package:pdf_editor/auth/views/main_auth/main_auth_view.dart';
import 'package:pdf_editor/bloc/app_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';
import 'package:pdf_editor/homepage/views/homepage_view.dart';
import 'package:pdf_editor/pdf_renderer/rust_pdf_renderer/rust_pdf_renderer.dart';
import 'package:pdf_editor/viewer/providers/pdf_viewer_related/scroll_controller_provider.dart';
import 'package:pdf_editor/viewer/views/pdf_viewer.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/word_explanation_modal.dart';

import 'auth/bloc/auth_bloc.dart';
import 'auth/bloc/auth_state.dart';
import 'auth/views/login/login_type_password_view.dart';
import 'auth/views/register/register_type_email_view.dart';
import 'auth/views/register/register_type_password_view.dart';
import 'bloc/app_states.dart';

import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'helpers/loading/loading_screen.dart';
import 'homepage/bloc/home_bloc.dart';
import 'homepage/views/tools/generics/select_files_views/order_files_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustPdfRenderer.instance().initialize();
  await AuthService().initialize();
  Lemmatizer().lemmasOnly("initialize");
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };

  runApp(ProviderScope(child: PdfReader()));
}

// class PDFEditor extends StatefulWidget {
//   const PDFEditor({super.key});

//   @override
//   State<PDFEditor> createState() => _PdfEditorState();
// }

// class _PdfEditorState extends State<PDFEditor> {
//   final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => AuthBloc(_navigatorKey),
//       child: MaterialApp(
//         navigatorKey: _navigatorKey,
//         routes: authRoutes,
//         debugShowCheckedModeBanner: false,
//         theme: ThemeData(
//           bottomSheetTheme:
//               const BottomSheetThemeData(backgroundColor: Colors.transparent),
//         ),
//         home: const MainAuthView(),
//       ),
//     );
//   }
// }

class PdfReader extends StatelessWidget {
  PdfReader({super.key});
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
        home: AppNavigator(),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  const AppNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    // context.read<AppBloc>().add(
    //       // const AppEventDisplayPdfViewer(
    //       //   '/data/user/0/com.example.pdf_editor/cache/file_picker/The-Selfish-Gene-R.-Dawkins-1976-WW-.pdf',
    //       // ),
    //       const AppEventDisplayHomePage(),
    //     );

    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        LoadingScreen().hide();
        if (state is AppStateNeedsAuthentication) {
          Navigator.of(context).push(MaterialPageRoute<MainAuthView>(
            builder: (_) {
              return BlocProvider<AppBloc>.value(
                value: BlocProvider.of<AppBloc>(context),
                child: BlocProvider(
                  create: (context) => AuthBloc(),
                  child: const MainAuthView(),
                ),
              );
            },
          ));
        }
        if (state is AppStateDisplayingPdfViewer && state.isLoading) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<PdfViewer>(
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
          Navigator.of(context).push(MaterialPageRoute<HomePageView>(
            builder: (_) {
              return BlocProvider(
                create: (context) => HomePageBloc(state.pdfFilesManager),
                child: BlocProvider<AppBloc>.value(
                  value: BlocProvider.of<AppBloc>(context),
                  child: const HomePageView(),
                ),
              );
            },
          ));
        }
      },
      child: const CircularProgressIndicator(),
    );
  }
}
