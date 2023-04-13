import 'package:equatable/equatable.dart';
import 'package:pdf_editor/viewer/crud/pdf_to_image_converter/pdf_to_image_converter.dart';

abstract class AppState extends Equatable {
  const AppState();
  @override
  List<Object?> get props => [];
}

class AppStateInitial extends AppState {
  const AppStateInitial();
}

class AppStateDisplayingPdfViewer extends AppState {
  const AppStateDisplayingPdfViewer(this.pdfToTmageConverter);
  final PdfToImage pdfToTmageConverter;
  @override
  List<Object?> get props => [pdfToTmageConverter];
}
