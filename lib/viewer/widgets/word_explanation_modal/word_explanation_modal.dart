import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lemmatizerx/lemmatizerx.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/views/word_explanation_modal_view.dart';

import '../../utils/oxford_dictionary_scraper/helpers/oxford_dictionary_api_client.dart';
import '../../utils/oxford_dictionary_scraper/helpers/oxford_dictionary_soup_parser.dart';
import '../../utils/oxford_dictionary_scraper/oxford_dictionary_scraper.dart';
import '../pdf_page/pdf_page_gesture_detector/pdf_page_gesture_detector.dart';
import 'helpers/contractions/contractions.dart';

class WordExplanationModal {
  WordExplanationModal(this.context);
  final BuildContext context;
  Size get size {
    final screenSize = MediaQuery.of(context).size;
    return Size(screenSize.width, screenSize.height * 0.7);
  }

  PersistentBottomSheetController? show({
    required String text,
    required String? userAgent,
  }) =>
      Scaffold.of(context).showBottomSheet(
        backgroundColor: Colors.transparent,
        (context) {
          return WordExplanationModalView(
            contraction: Contractions.english.contract(text),
            size: size,
            scraper: OxfordDictionaryScraper(
              lemmatizer: Lemmatizer(),
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
}
