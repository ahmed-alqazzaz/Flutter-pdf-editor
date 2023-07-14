import 'package:flutter/material.dart';
import 'package:pdf_editor/crud/pdf_db_manager/data/data.dart';

@immutable
abstract class HomePageEvent {
  const HomePageEvent();
}

class HomePageEventDisplayFiles extends HomePageEvent {
  final bool Function(PdfFile)? filter;
  const HomePageEventDisplayFiles({this.filter});
}

class HomePageEventAddFile extends HomePageEvent {
  final PdfFile file;
  const HomePageEventAddFile(this.file);
}

class HomePageEventUpdateFile extends HomePageEvent {
  final PdfFile file;
  const HomePageEventUpdateFile(this.file);
}

class HomePageEventDeleteFile extends HomePageEvent {
  final PdfFile file;
  const HomePageEventDeleteFile(this.file);
}
