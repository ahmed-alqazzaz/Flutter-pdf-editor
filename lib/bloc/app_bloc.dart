import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';
import 'package:pdf_editor/bloc/app_states.dart';
import 'package:pdf_editor/viewer/crud/pdf_to_image_converter/pdf_to_image_converter.dart';

void x() {}

class AppBloc extends Bloc<AppEvent, AppState> {
  PdfToImage? pdfToImageConverter;
  AppBloc() : super(const AppStateInitial()) {
    on<AppEventDisplayPdfViewer>(
      (event, emit) async {
        pdfToImageConverter = await PdfToImage.initialize(event.pdfPath);
        emit(AppStateDisplayingPdfViewer(pdfToImageConverter!));
      },
    );
  }
}
