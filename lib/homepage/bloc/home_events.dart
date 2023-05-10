import 'package:flutter/material.dart';
import 'package:pdf_editor/crud/pdf_db_manager/data/data.dart';

@immutable
abstract class HomePageEvent {
  const HomePageEvent();
}

class HomePageEventDisplayFiles extends HomePageEvent {
  const HomePageEventDisplayFiles();
}

class HomePageEventDisplayTools extends HomePageEvent {
  const HomePageEventDisplayTools();
}

class HomePageEventAddFile extends HomePageEvent {
  final PdfFile file;
  const HomePageEventAddFile(this.file);
}

class HomePageEventUpdateFile extends HomePageEvent {
  final PdfFile file;
  const HomePageEventUpdateFile(this.file);
}
