import 'package:flutter/semantics.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

extension IsGestureWithingRange on TextElement {
  bool isGestureWithinRange(Offset location, Rect boundingBox) {
    if (location.dx >= boundingBox.left &&
        location.dx <= boundingBox.right &&
        location.dy >= boundingBox.top &&
        location.dy <= boundingBox.bottom) {
      return true;
    }
    return false;
  }
}
