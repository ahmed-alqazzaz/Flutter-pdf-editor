import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';
import 'package:pdf_editor/bloc/app_states.dart';
import 'package:pdf_editor/viewer/crud/pdf_to_image_converter.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppStateInitial()) {
    on<AppEventDisplayPdfViewer>(
      (event, emit) async {
        if (PdfToImage().isDocumentOpen) {
          await PdfToImage().close();
        }
        await PdfToImage().open(event.pdfPath);
        await PdfToImage().cacheAll();
        emit(const AppStateDisplayingPdfViewer());
      },
    );
  }
}
