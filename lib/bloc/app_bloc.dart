import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';
import 'package:pdf_editor/bloc/app_states.dart';
import 'package:pdf_editor/crud/pdf_db_manager/pdf_files_manager.dart';

import '../auth/auth_service/auth_service.dart';
import '../auth/auth_service/auth_user.dart';
import '../pdf_renderer/renderer.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateInitial()) {
    _authStateListener = AuthService().authStateChanges.listen(
      (user) {
        add(user != null
            ? const AppEventDisplayHomePage()
            : const AppEventNeedsAuthentication());
      },
    );
    on<AppEventDisplayPdfViewer>(
      (event, emit) async {
        final pdfName = event.pdfPath.split("/").last.split(".pdf").first;
        emit(AppStateDisplayingPdfViewer(isLoading: true, pdfName: pdfName));
        await PdfRenderer.open(event.pdfPath).then(
          (value) {
            emit(
              AppStateDisplayingPdfViewer(
                  isLoading: false,
                  pdfToTmageConverter: value,
                  pdfName: pdfName),
            );
          },
        );
      },
    );
    on<AppEventDisplayHomePage>(
      (event, emit) async =>
          emit(AppStateDisplayingHomePage(await PdfFilesManager.initialize())),
    );
    on<AppEventNeedsAuthentication>(
      (event, emit) {
        emit(const AppStateNeedsAuthentication());
      },
    );
  }
  late final StreamSubscription<AuthUser?> _authStateListener;
  AuthUser? get currentUser => AuthService().currentUser;
  Future<void> signOut() async => await AuthService().signOut();

  @override
  Future<void> close() {
    _authStateListener.cancel();
    return super.close();
  }
}
