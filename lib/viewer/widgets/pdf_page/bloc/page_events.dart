import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

@immutable
abstract class PageEvent {
  const PageEvent();
}

class PageEventInitial extends PageEvent {
  const PageEventInitial();
}

class PageEventUpdateDisplay extends PageEvent {
  const PageEventUpdateDisplay({
    required this.pageNumber,
    required this.scaleFactor,
    required this.pageVisibleBounds,
    this.extractedText,
  });

  final int pageNumber;
  final double scaleFactor;
  final Rect pageVisibleBounds;
  final RecognizedText? extractedText;
}
