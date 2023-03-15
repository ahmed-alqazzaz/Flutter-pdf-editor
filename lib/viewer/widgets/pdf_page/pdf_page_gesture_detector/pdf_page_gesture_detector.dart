import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:pdf_editor/viewer/crud/text_recognizer.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page_gesture_detector/word_click_detector.dart';
import 'package:rxdart/rxdart.dart';

class PdfPageGestureDetector extends StatelessWidget {
  const PdfPageGestureDetector({
    super.key,
    required this.child,
    required this.appBarsVisibilityController,
    this.extractedText,
    required this.wordOnPressController,
  });
  final Widget child;
  final BehaviorSubject<bool> appBarsVisibilityController;
  final BehaviorSubject<Word?> wordOnPressController;
  final WordCollection? extractedText;

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: {
        DoubleTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
          () => DoubleTapGestureRecognizer(),
          (DoubleTapGestureRecognizer instance) {
            instance.onDoubleTap = () {
              // hide/show app bar when there is a double click
              final areAppbarsVisible = appBarsVisibilityController.valueOrNull;

              appBarsVisibilityController.sink.add(
                areAppbarsVisible != null ? !areAppbarsVisible : false,
              );
            };
          },
        ),
        PdfPageGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<PdfPageGestureRecognizer>(
          () => PdfPageGestureRecognizer(),
          (PdfPageGestureRecognizer instance) {
            instance.onTapDown = (localPosition) async {
              if (extractedText != null) {
                for (final line in extractedText!.lines) {
                  for (final word in line.words) {
                    if (word.isGestureWithinRange(
                        localPosition, extractedText!.scaleFactor)) {
                      wordOnPressController.sink.add(word);
                      Timer(const Duration(seconds: 3), () {
                        wordOnPressController.sink.add(null);
                      });
                    }
                  }
                }
              }
            };
          },
        ),
      },
      child: child,
    );
  }
}
