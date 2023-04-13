import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

import 'dart:ui' as ui;

import 'data.dart';

@immutable
abstract class PageState extends Equatable {
  const PageState();
  @override
  List<Object?> get props => [];
}

class PageStateDisplayBlank extends PageState {
  const PageStateDisplayBlank();
}

class PageStateDisplayCache extends PageState {
  const PageStateDisplayCache();
}

class PageStateDisplayMain extends PageState {
  const PageStateDisplayMain({
    required this.mainImage,
    required this.scaleFactor,
    this.highResolutionPatch,
    this.extractedText,
  });

  final ui.Image mainImage;
  final double scaleFactor;
  final RecognizedText? extractedText;
  final HighResolutionPatch? highResolutionPatch;

  @override
  List<Object?> get props => [
        extractedText,
        scaleFactor,
        mainImage,
        highResolutionPatch,
      ];
}
