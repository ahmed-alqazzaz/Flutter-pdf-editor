import 'package:flutter/semantics.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

extension AdjustedBoundingBox on TextElement {
  Rect adjustedBoundingBox(double adjustmentFactor) {
    final originalBoundingBox = boundingBox;
    return Rect.fromLTRB(
      originalBoundingBox.left * adjustmentFactor,
      originalBoundingBox.top * adjustmentFactor,
      originalBoundingBox.right * adjustmentFactor,
      originalBoundingBox.bottom * adjustmentFactor,
    );
  }
}
