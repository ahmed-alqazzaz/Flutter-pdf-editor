import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/foundation.dart';
import 'package:lemmatizerx/lemmatizerx.dart';
import 'package:pdf_editor/viewer/utils/oxford_dictionary_scraper/data/data.dart';

import 'exceptions.dart';
import 'helpers/oxford_dictionary_api_client.dart';
import 'helpers/oxford_dictionary_soup_parser.dart';

@immutable
class OxfordDictionaryScraper {
  const OxfordDictionaryScraper({
    required this.lemmatizer,
    required this.client,
  });

  final OxfordDictionaryApiClient client;
  final Lemmatizer lemmatizer;
  final soupParser = const OxfordDictionarySoupParser();

  Future<List<Lexicon>> search(List<String> words) async {
    // create a list of possible lemmas
    final lemmas = words
        .map((word) {
          // remove unnecessary chars
          word = word.replaceAll(RegExp(r'[^a-zA-Z]'), '');

          final lemmas = lemmatizer.lemmasOnly(word);
          return lemmas.isNotEmpty ? lemmas : [word];
        })
        .expand((lemmas) => lemmas)
        .toList();

    // search each one of the possible lemmas
    // and filter out null values
    final results = await Future.wait(
      _searchLemmas(lemmas.isNotEmpty ? lemmas : words),
    ).then(
      (results) => results.whereType<Lexicon>().toList(),
    );

    return (results.isEmpty) ? throw const WordUnavailableException() : results;
  }

  Iterable<Future<Lexicon?>> _searchLemmas(List<String> lemmas) sync* {
    for (final lemma in lemmas) {
      yield client.fetchWord(lemma).then(
        (response) {
          final sp = response != null ? BeautifulSoup(response) : null;
          if (sp != null) {
            return soupParser.extractLexicon(sp);
          }
          return null;
        },
      );
    }
  }
}
