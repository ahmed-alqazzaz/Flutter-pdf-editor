import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:pdf_editor/crud/pdf_to_image_converter/pdf_to_image_converter.dart';

@immutable
class PageImage {
  const PageImage({
    required this.path,
    required this.scaleFactor,
    required this.size,
  });
  final Size size;
  final String path;
  final double scaleFactor;
}
