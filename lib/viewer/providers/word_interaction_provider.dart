import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordInteractionModel extends ChangeNotifier {
  Rect? _wordBoundingBox;
  PersistentBottomSheetController? _bottomSheetController;

  Rect? get wordBoundingBox => _wordBoundingBox;
  bool get isThereTappedWord => _wordBoundingBox != null;

  void updateTappedWord({
    required final Rect wordBoundingBox,
    PersistentBottomSheetController? bottomSheetController,
  }) {
    _wordBoundingBox = wordBoundingBox;
    _bottomSheetController = bottomSheetController;
    notifyListeners();
  }

  void reset() {
    _bottomSheetController?.close();
    _wordBoundingBox = null;
    _bottomSheetController = null;
    notifyListeners();
  }
}

final wordInteractionProvider = ChangeNotifierProvider<WordInteractionModel>(
  (ref) => WordInteractionModel(),
);
