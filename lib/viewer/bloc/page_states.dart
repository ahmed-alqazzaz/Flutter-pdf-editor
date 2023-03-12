import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page.dart';

import 'dart:ui' as ui;
import '../crud/text_recognizer.dart';

@immutable
abstract class PageState extends Equatable {
  const PageState();
  @override
  List<Object?> get props => [];
}

class PageStateInitial extends PageState {
  const PageStateInitial();
}

class PageStateUpdatingDisplay extends PageState {
  const PageStateUpdatingDisplay({
    required this.mainImage,
    required this.scaleFactor,
    this.highResolutionPatch,
    this.extractedText,
  });

  final ui.Image mainImage;
  final double scaleFactor;
  final WordCollection? extractedText;
  final HighResolutionPatch? highResolutionPatch;

  @override
  List<Object?> get props =>
      [extractedText, scaleFactor, mainImage, highResolutionPatch];
}
