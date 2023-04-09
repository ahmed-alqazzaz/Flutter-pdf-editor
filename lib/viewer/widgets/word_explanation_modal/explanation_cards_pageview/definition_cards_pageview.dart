import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/explanation_cards_pageview/generics/generics/generic_explanation_card.dart';

import '../../../utils/oxford_dictionary_scraper/data/data.dart';
import 'generics/generics/generic_explanation_builder.dart';

class DefinitionCardsPageView extends StatelessWidget {
  const DefinitionCardsPageView({
    super.key,
    required this.senses,
    required this.pageController,
    required this.height,
  });

  static const double _width = 360.0;

  final double height;
  final PageController pageController;
  final List<Sense> senses;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: height,
      child: PageView.builder(
        padEnds: false,
        controller: pageController,
        itemCount: senses.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          final sense = senses[index];
          final definition = sense.definition;
          final allExamples = sense.examples;
          final examples = <Example>[];
          if (allExamples != null) {
            for (final example in allExamples.take(5)) {
              int totalCharacters =
                  definition.main.length + (definition.grammar?.length ?? 0);
              if (totalCharacters > 300) {
                break;
              }
              examples.add(example);
              totalCharacters +=
                  example.regularText.length + (example.boldText?.length ?? 0);
            }
          }

          return GenericExplanationCard(
            cardIndex: '${senses.length}/${index + 1}',
            shape: RoundedRectangleBorder(
              side: const BorderSide(
                width: 1.0,
                color: Colors.deepPurple,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 35),
              child: GenericExplanationBuilder(
                definition: definition,
                examples: examples,
              ),
            ),
          );
        },
      ),
    );
  }
}
