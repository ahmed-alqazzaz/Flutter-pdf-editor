import 'package:flutter/material.dart';

@immutable
abstract class AppEvent {
  const AppEvent();
}

class AppEventDisplayPdfViewer extends AppEvent {
  const AppEventDisplayPdfViewer(this.pdfPath);
  final String pdfPath;
}

class AppEventDisplayHomePage extends AppEvent {
  const AppEventDisplayHomePage();
}

class AppEventNeedsAuthentication extends AppEvent {
  const AppEventNeedsAuthentication();
}
