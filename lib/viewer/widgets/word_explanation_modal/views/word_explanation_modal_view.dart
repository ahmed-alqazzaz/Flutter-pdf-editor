import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf_editor/viewer/providers/word_explanation_modal_related/word_explanation_provider.dart';

import 'package:pdf_editor/viewer/widgets/word_explanation_modal/views/modal_navigation_bar.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/views/word_explanation_body.dart';

import 'package:tuple/tuple.dart';

import '../../../utils/oxford_dictionary_scraper/exceptions.dart';
import '../../../utils/oxford_dictionary_scraper/oxford_dictionary_scraper.dart';

class WordExplanationModalView extends StatelessWidget {
  const WordExplanationModalView({
    super.key,
    required this.contraction,
    required this.scraper,
    required this.size,
  });

  final OxfordDictionaryScraper scraper;
  final Tuple2<List<String>, List<String>> contraction;
  final Size size;
  static const double explanationCardsVerticalPadding = 15.0;
  static const int _expansionPanelsCount = 2;
  static const double _expansionPanelHeight = 57;
  static const double expansionPanelsHeight =
      _expansionPanelHeight * _expansionPanelsCount;
  static const backgroundColor = Color.fromARGB(255, 244, 246, 250);
  @override
  Widget build(BuildContext context) {
    final List<String> words = [contraction.item1, contraction.item2]
        .expand((element) => element)
        .toList();

    return SizedBox(
      height: size.height,
      width: size.width,
      child: FutureBuilder(
        future: scraper.search(words),
        builder: (context, snapshot) {
          if (snapshot.error is WordLoadingException) {
            return const Text("Connection Error");
          } else if (snapshot.error is WordUnavailableException) {
            return const Text("Word Not Found");
          } else if (snapshot.error
                  is OxfordDictionaryScraperUnknownException ||
              snapshot.error is OxfordDictionaryBlockedRequestException) {
            return const Text("An error occured");
          } else if (snapshot.hasData) {
            final mainWords = snapshot.data!;
            final similarWords = mainWords
                .map((word) => word.similarWords.toList())
                .expand((element) => element)
                .where((similarWord) => similarWord.pos.isNotEmpty);
            final phrasalVerbs = mainWords
                .map((word) => word.phrasalVerbs)
                .expand((element) => element);

            return ProviderScope(
              overrides: [
                wordExplanationProvider
                    .overrideWith((ref) => WordExplanationController([
                          ...mainWords.map((word) => Future.value(word)),
                          ...similarWords.map((similarWord) {
                            return similarWord.fetch(scraper, similarWord.link);
                          }),
                          ...phrasalVerbs.map((phrasalVerb) {
                            return phrasalVerb.fetch(scraper, phrasalVerb.link);
                          })
                        ]))
              ],
              child: SizedBox(
                height: size.height,
                child: ExplanationModalNavigationBar(
                  headerWords: [...mainWords, ...similarWords, ...phrasalVerbs],
                  body: WordExplanationBody(
                    modalHeight: size.height,
                  ),
                ),
              ),
            );
          } else {
            return Container(
              alignment: Alignment.center,
              color: backgroundColor,
              child: const CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
