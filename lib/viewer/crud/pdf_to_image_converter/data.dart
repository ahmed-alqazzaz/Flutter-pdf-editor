import 'dart:ui';
import 'package:flutter/foundation.dart';

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
