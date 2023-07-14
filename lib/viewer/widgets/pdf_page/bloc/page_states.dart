// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui' as ui;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

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

  PageStateDisplayMain copyWith({
    ui.Image? mainImage,
    double? scaleFactor,
    RecognizedText? extractedText,
    HighResolutionPatch? highResolutionPatch,
  }) {
    return PageStateDisplayMain(
      mainImage: mainImage ?? this.mainImage,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      extractedText: extractedText ?? this.extractedText,
      highResolutionPatch: highResolutionPatch ?? this.highResolutionPatch,
    );
  }
}
