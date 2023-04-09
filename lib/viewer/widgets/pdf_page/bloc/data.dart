import 'package:flutter/foundation.dart';
import 'dart:ui';

@immutable
class HighResolutionPatch {
  const HighResolutionPatch({
    required this.image,
    required this.details,
  });
  final Image image;
  final Rect details;
}
