import 'dart:io';

import 'package:fk_user_agent/fk_user_agent.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:lemmatizerx/lemmatizerx.dart';

import 'package:pdf_editor/viewer/utils/text_recognition/adjusted_bounding_box.dart';
import 'package:pdf_editor/viewer/utils/text_recognition/is_gesture_within_range.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page_gesture_detector/word_tap_detector.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/contractions/contractions.dart';
import 'package:rxdart/rxdart.dart';

import '../../../utils/oxford_dictionary_scraper/helpers/oxford_dictionary_api_client.dart';
import '../../../utils/oxford_dictionary_scraper/helpers/oxford_dictionary_soup_parser.dart';
import '../../../utils/oxford_dictionary_scraper/oxford_dictionary_scraper.dart';
import '../../word_explanation_modal/word_explanation_modal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PdfPageGestureDetector extends ConsumerWidget {
  const PdfPageGestureDetector({
    super.key,
    required this.child,
    required this.pdfPageWidth,
    required this.scaleFactor,
    required this.appBarsVisibilityController,
    required this.scrollController,
    this.extractedText,
  });

  final BehaviorSubject<bool> appBarsVisibilityController;
  final Widget child;
  final RecognizedText? extractedText;
  final double pdfPageWidth;
  final double scaleFactor;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordInteractionModel = ref.read(wordInteractionProvider);
    return RawGestureDetector(
      gestures: {
        DoubleTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<DoubleTapGestureRecognizer>(
          () => DoubleTapGestureRecognizer(),
          (DoubleTapGestureRecognizer instance) {
            instance.onDoubleTap = () {
              // hide/show app bars when there is a double click
              final areAppbarsVisible = appBarsVisibilityController.valueOrNull;
              appBarsVisibilityController.sink.add(
                areAppbarsVisible != null ? !areAppbarsVisible : false,
              );
            };
          },
        ),
        WordTapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<WordTapGestureRecognizer>(
          () => WordTapGestureRecognizer(),
          (WordTapGestureRecognizer instance) {
            instance.onTapUp = (PointerUpEvent event) async {
              // in case word highlight is present remove
              // it along with the bottomSheet
              if (wordInteractionModel.isThereTappedWord) {
                wordInteractionModel.reset();
                return;
              }
              if (extractedText != null) {
                final renderBox = context.findRenderObject() as RenderBox;
                final screenHeight = MediaQueryData.fromWindow(
                  WidgetsBinding.instance.window,
                ).size.height;

                for (var block in extractedText!.blocks) {
                  for (var line in block.lines) {
                    for (var element in line.elements) {
                      const extractedTextScaleFactor = 4;
                      final adjustedBoundingBox = element.adjustedBoundingBox(
                        (renderBox.size.width / pdfPageWidth) /
                            extractedTextScaleFactor,
                      );
                      if (element.isGestureWithinRange(
                          event.localPosition, adjustedBoundingBox)) {
                        final wordBottomBorder = renderBox.localToGlobal(
                          Offset(0, adjustedBoundingBox.bottom),
                        );

                        // the height of the page that won't be covered by the bottom sheet
                        final pageUncoveredHeight =
                            screenHeight - bottomSheetHeight;

                        // scroll up in case the pressed word
                        // will be covered by the bottom sheet
                        if (wordBottomBorder.dy > pageUncoveredHeight) {
                          final scrollOffset = scrollController.offset -
                              (pageUncoveredHeight - wordBottomBorder.dy) /
                                  scaleFactor;
                          scrollController.animateTo(
                            scrollOffset,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastOutSlowIn,
                          );
                        }
                        wordInteractionModel.updateTappedWord(
                          wordBoundingBox: adjustedBoundingBox,
                          bottomSheetController: await showWordExplanation(
                            context: context,
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
            };
          },
        ),
      },
      child: child,
    );
  }
}

Future<PersistentBottomSheetController?> showWordExplanation({
  required BuildContext context,
  required String text,
  required String? userAgent,
}) async =>
    Scaffold.of(context).showBottomSheet(
      (context) {
        return WordExplanationModal(
          text: Contractions.english.contract(text),
          height: bottomSheetHeight,
          scraper: OxfordDictionaryScraper(
            lemmatizer: Lemmatizer(),
            soupParser: OxfordDictionarySoupParser(),
            client: userAgent != null
                ? OxfordDictionaryApiClient(
                    client: HttpClient(),
                    userAgent: userAgent,
                  )
                : OxfordDictionaryApiClient.withRandomAgent(HttpClient()),
          ),
        );
      },
    );

const bottomSheetHeight = 600.0;

// final height = MediaQueryData.fromWindow(
//   WidgetsBinding.instance.window,
// ).size.height;
// final pageUncoveredHeight = height - bottomSheetHeight;
// const pageHeight = 612 * 412 / 396;
// final scrollOffset = scrollController.offset;
// late final double x;
// if (scrollOffset < pageHeight / 2) {
//   if (event.position.dy + scrollOffset < 636) {
//     x = -scrollOffset;
//     log('1');
//   } else {
//     x = pageHeight - scrollOffset;
//     log('2');
//   }
// } else {
//   if (event.position.dy + (scrollOffset % pageHeight) <
//       636) {
//     x = -(scrollOffset % pageHeight);
//     log('3');
//   } else {
//     x = pageHeight - (scrollOffset % pageHeight);
//     log('4');
//   }
// }
// if (word.position.bottom + x > pageUncoveredHeight) {
//   scrollController.animateTo(
//     scrollController.offset +
//         (word.position.bottom + x - pageUncoveredHeight),
//     duration: const Duration(milliseconds: 500),
//     curve: Curves.fastOutSlowIn,
//   );
// }
