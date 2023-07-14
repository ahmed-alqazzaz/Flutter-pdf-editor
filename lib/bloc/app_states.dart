import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pdf_editor/crud/pdf_db_manager/pdf_files_manager.dart';

import '../pdf_renderer/renderer.dart';

@immutable
abstract class AppState extends Equatable {
  const AppState();
  @override
  List<Object> get props => [];
}

class AppStateInitial extends AppState {
  const AppStateInitial();
}

class AppStateDisplayingPdfViewer extends AppState {
  const AppStateDisplayingPdfViewer({
    this.pdfToTmageConverter,
    required this.isLoading,
  });
  final bool isLoading;
  final PdfRenderer? pdfToTmageConverter;

  @override
  List<Object> get props => [isLoading];
}

class AppStateDisplayingHomePage extends AppState {
  const AppStateDisplayingHomePage(this.pdfFilesManager);
  final PdfFilesManager pdfFilesManager;

  @override
  List<Object> get props => [pdfFilesManager];
}

class AppStateNeedsAuthentication extends AppState {
  const AppStateNeedsAuthentication();
}
