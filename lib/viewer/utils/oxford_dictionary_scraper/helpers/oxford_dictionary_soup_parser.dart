import 'package:beautiful_soup_dart/beautiful_soup.dart';
import 'package:flutter/cupertino.dart';

import '../data/data.dart';

@immutable
class OxfordDictionarySoupParser {
  const OxfordDictionarySoupParser();
  Lexicon extractLexicon(BeautifulSoup sp) {
    final idiomElements = sp.findAll("span", class_: "idm-g");
    final phrasalVerbElements = sp.find('ul', class_: 'pvrefs')?.findAll('li');
    final similarWordElements =
        sp.find('div', id: 'relatedentries')?.find('dd')?.findAll('li');
    final senses = _sensesOrganizer(_mainSegmentExtractor(sp));
    return Lexicon(
      word: sp.find('div', class_: 'top-g')!.find('h1')!.text,
      main: senses != null ? MainSegment(senses: senses) : null,
      idioms: idiomElements.map(
        (idiomSpan) => Idiom(
          idiom: idiomSpan.find('span', class_: 'idm')!.text,
          senses: _sensesOrganizer(
            idiomSpan.find('ol'),
          ),
        ),
      ),
      phrasalVerbs: phrasalVerbElements?.map(
            (phrasalVerb) => PhrasalVerb(
              link: phrasalVerb.find('a')!.getAttrValue('href')!,
              text: phrasalVerb.find('span')!.text,
            ),
          ) ??
          [],
      similarWords: similarWordElements?.map(
            (similarWord) => SimilarWord(
              text: (similarWord.find('span')!.text.split(" ")..removeLast())
                  .join(' '),
              link: similarWord.find('a')!.getAttrValue('href')!,
              pos: similarWord.find('pos-g')?.text ?? "",
            ),
          ) ??
          [],
      pos: sp.find('span', class_: 'pos')!.text,
    );
  }

  Iterable<Sense>? _sensesOrganizer(Bs4Element? senses) {
    return senses?.findAll('li', class_: "sense").map(
          (element) => Sense(
            sng: element.parent?.find('h2')?.text,
            definition: Definition(
              grammar: element.find('span', class_: 'grammar')?.text,
              main: element.find('span', class_: 'def')!.text,
            ),
            examples: element.find("ul", class_: 'examples')?.findAll('li').map(
                  (example) => Example(
                    boldText: example.find('span', class_: 'cf')?.text,
                    regularText: example.find('span', class_: 'x')!.text,
                  ),
                ),
          ),
        );
  }

  Bs4Element? _mainSegmentExtractor(BeautifulSoup sp) {
    final idiomSpans = sp.findAll("span", class_: "idm-g");
    Bs4Element? mainSegmentOrderedList =
        sp.find('ol', class_: 'senses_multiple');
    if (mainSegmentOrderedList == null ||
        idiomSpans.contains(mainSegmentOrderedList)) {
      mainSegmentOrderedList = sp.find('ol', class_: 'sense_single');
      if (idiomSpans.contains(mainSegmentOrderedList)) {
        mainSegmentOrderedList = null;
      }
    }
    return mainSegmentOrderedList;
  }
}
