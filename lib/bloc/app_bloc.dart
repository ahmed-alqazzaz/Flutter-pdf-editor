import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';
import 'package:pdf_editor/bloc/app_states.dart';
import 'package:pdf_editor/viewer/crud/pdf_to_image_converter/pdf_to_image_converter.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  PdfToImage? pdfToImageConverter;
  AppBloc() : super(const AppStateInitial()) {
    on<AppEventDisplayPdfViewer>(
      (event, emit) async {
        emit(const AppStateDisplayingPdfViewer(isLoading: true));
        emit(AppStateDisplayingPdfViewer(
          isLoading: false,
          pdfToTmageConverter: await PdfToImage.open(event.pdfPath),
        ));
      },
    );
  }
}
