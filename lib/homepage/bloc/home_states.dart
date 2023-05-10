import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pdf_editor/crud/pdf_to_image_converter/data.dart';
import 'package:tuple/tuple.dart';

import '../../crud/pdf_db_manager/data/data.dart';

@immutable
abstract class HomePageState extends Equatable {
  const HomePageState();
  @override
  List<Object> get props => [];
}

class HomePageStateDisplayingFiles extends HomePageState {
  final List<PdfFile> pdfFiles;
  const HomePageStateDisplayingFiles(this.pdfFiles);

  @override
  List<Object> get props => [pdfFiles];
}

class HomePageStateDisplayingTools extends HomePageState {
  const HomePageStateDisplayingTools();
}
