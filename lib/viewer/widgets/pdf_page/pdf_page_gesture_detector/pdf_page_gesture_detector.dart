import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf_editor/viewer/providers/pdf_viewer_related/appbars_visibility_provider.dart';

import 'package:pdf_editor/viewer/utils/text_recognition/adjusted_bounding_box.dart';
import 'package:pdf_editor/viewer/utils/text_recognition/is_gesture_within_range.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page_gesture_detector/word_tap_detector.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/word_explanation_modal.dart';

import '../../../providers/pdf_viewer_related/scroll_controller_provider.dart';
import '../../../providers/pdf_viewer_related/word_interaction_provider.dart';

import '../bloc/page_bloc.dart';

class PdfPageGestureDetector extends ConsumerWidget {
  const PdfPageGestureDetector({
    super.key,
    required this.child,
    required this.pdfPageWidth,
    required this.scaleFactor,
    this.extractedText,
  });
  final Widget child;
  final RecognizedText? extractedText;
  final double pdfPageWidth;
  final double scaleFactor;

  // hide/show app bars when there is a double click
  void onDoubleTap(WidgetRef ref) {
    final appbarsVisibilityModel = ref.read(appbarVisibilityProvider);
    if (appbarsVisibilityModel.areAppbarsVisible) {
      appbarsVisibilityModel.hideAppbars();
    } else {
      appbarsVisibilityModel.showAppBars();
    }
  }

  void onTapUp({
    required BuildContext context,
    required WidgetRef ref,
    required Offset position,
  }) async {
    final wordExplanationModal = WordExplanationModal(context);
    final wordInteractionModel = ref.read(wordInteractionProvider);
    final scrollControllerModel = ref.read(scrollControllerProvider);
    final screenHeight = MediaQueryData.fromWindow(
      WidgetsBinding.instance.window,
    ).size.height;
    // the height of the page that won't be covered by the bottom sheet
    final pageUncoveredHeight = screenHeight - wordExplanationModal.size.height;
    final renderBox = context.findRenderObject() as RenderBox;

    // in case word highlight is present remove
    // it along with the bottomSheet
    if (wordInteractionModel.isExplanationModalPresent) {
      wordInteractionModel.reset();
      return;
    }
    if (extractedText != null) {
      for (var block in extractedText!.blocks) {
        for (var line in block.lines) {
          for (var element in line.elements) {
            final elementAdjustedBoundingBox = element.adjustedBoundingBox(
              (renderBox.size.width / pdfPageWidth) /
                  (PageBloc.cachedPageWidth / pdfPageWidth),
            );
            print('$elementAdjustedBoundingBox ${element.text} $position');
            final wordBottomBorder = renderBox.localToGlobal(
              Offset(0, elementAdjustedBoundingBox.bottom),
            );

            // in case a word has been tapped
            if (element.isGestureWithinRange(
              position,
              elementAdjustedBoundingBox,
            )) {
              // scroll up in case the pressed word
              // will be covered by the bottom sheet
              if (wordBottomBorder.dy > pageUncoveredHeight) {
                scrollControllerModel.animateBy(
                  (wordBottomBorder.dy - pageUncoveredHeight) / scaleFactor,
                );
              }
              wordInteractionModel.updateTappedWord(
                wordBoundingBox: elementAdjustedBoundingBox,
                bottomSheetController: wordExplanationModal.show(
                  text: element.text,
                  userAgent: await FkUserAgent.init().then(
                    (value) => FkUserAgent.webViewUserAgent,
                  ),
                ),
              );
            }
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RawGestureDetector(
      gestures: {
        DoubleTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
          () => DoubleTapGestureRecognizer(),
          (DoubleTapGestureRecognizer instance) {
            instance.onDoubleTap = () => onDoubleTap(ref);
          },
        ),
        WordTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<WordTapGestureRecognizer>(
          () => WordTapGestureRecognizer(),
          (WordTapGestureRecognizer instance) {
            instance.onTapUp = (PointerUpEvent event) => onTapUp(
                  context: context,
                  ref: ref,
                  position: event.localPosition,
                );
          },
        ),
      },
      child: child,
    );
  }
}
