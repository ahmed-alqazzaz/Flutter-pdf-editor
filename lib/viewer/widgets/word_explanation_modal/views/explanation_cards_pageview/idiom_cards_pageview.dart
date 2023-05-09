import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/views/explanation_cards_pageview/generics/generic_explanation_builder.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/views/explanation_cards_pageview/generics/generic_explanation_card.dart';

import '../../../../utils/oxford_dictionary_scraper/data/data.dart';

class IdiomsCardsPageView extends StatelessWidget {
  const IdiomsCardsPageView({
    super.key,
    required this.idioms,
  });

  final List<Idiom> idioms;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PageView.builder(
      itemCount: idioms.length,
      reverse: true,
      controller: PageController(viewportFraction: 0.85),
      itemBuilder: (context, index) {
        return GenericExplanationCard(
          cardIndex: '${idioms.length}/${index + 1}',
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.0,
              color: Colors.deepPurple,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.1,
                  vertical: 15,
                ),
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        idioms[index].idiom,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const Divider(
                        color: Color.fromRGBO(186, 186, 186, 1),
                      )
                    ],
                  ),
                ),
              ),
              if (idioms[index].senses != null) ...[
                for (final sense in idioms[index].senses!) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: GenericExplanationBuilder(
                      definition: sense.definition,
                      examples: sense.examples,
                    ),
                  ),
                ]
              ]
            ],
          ),
        );
      },
    );
  }
}
