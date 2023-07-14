import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/views/word_explanation_modal_view.dart';

import '../../../providers/word_explanation_modal_related/word_explanation_provider.dart';
import '../../../utils/oxford_dictionary_scraper/data/data.dart';
import 'explanation_cards_pageview/definition_cards_pageview.dart';
import 'explanation_cards_pageview/idiom_cards_pageview.dart';
import '../helpers/expansion_panel_builder.dart';
import 'modal_navigation_bar.dart';

class WordExplanationBody extends ConsumerWidget {
  const WordExplanationBody({
    super.key,
    required this.modalHeight,
  });

  final double modalHeight;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final wordsExplanationController = ref.watch(wordExplanationProvider);
    final explanationCardsPageViewHeight = modalHeight -
        ExplanationModalNavigationBar.height -
        WordExplanationModalView.expansionPanelsHeight -
        16;
    void updateExplanation(Future<Lexicon> explanation) {
      wordsExplanationController
          .words[wordsExplanationController.selectedWordIndex] = explanation;
    }

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Color.fromRGBO(186, 186, 186, 100),
          ),
        ),
      ),
      width: width,
      child: FutureBuilder(
        future: wordsExplanationController
            .words[wordsExplanationController.selectedWordIndex],
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            updateExplanation(Future.value(snapshot.data!));
            final mainSenses = snapshot.data!.main?.senses.toList();
            final idioms = snapshot.data!.idioms.toList();
            return Container(
              color: Colors.white,
              child: ExpansionPanelBuilder(
                backgroundColor: WordExplanationModalView.backgroundColor,
                explanationCardsPageViewHeight: explanationCardsPageViewHeight,
                children: {
                  ExpansionPanelItem(
                    header: const ListTile(
                      title: Text('Definitions'),
                    ),
                    body: mainSenses != null
                        ? DefinitionCardsPageView(
                            senses: mainSenses,
                            pageController:
                                PageController(viewportFraction: 0.85),
                          )
                        : Container(),
                  ),

                  // the framework is being glitchy so I had to include
                  // the idiom panel twice
                  ExpansionPanelItem(
                      header: const ListTile(
                        title: Text('Idioms'),
                      ),
                      body: IdiomsCardsPageView(
                        idioms: idioms,
                      )),
                  ExpansionPanelItem(
                    header: const ListTile(
                      title: Text('Idioms'),
                    ),
                    body: IdiomsCardsPageView(
                      idioms: idioms,
                    ),
                  ),
                }.toList(),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
