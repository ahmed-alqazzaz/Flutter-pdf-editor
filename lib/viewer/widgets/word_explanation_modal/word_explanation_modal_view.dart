import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/explanation_cards_pageview/definition_cards_pageview.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/explanation_cards_pageview/idiom_cards_pageview.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

import '../../utils/oxford_dictionary_scraper/exceptions.dart';
import '../../utils/oxford_dictionary_scraper/oxford_dictionary_scraper.dart';
import 'expansion_panel_builder.dart';
import 'modal_top_area/modal_top_area.dart';

class WordExplanationModalView extends StatefulWidget {
  const WordExplanationModalView({
    super.key,
    required this.text,
    required this.size,
    required this.scraper,
  });

  final OxfordDictionaryScraper scraper;
  final Size size;
  final Tuple2<List<String>, List<String>> text;
  @override
  State<WordExplanationModalView> createState() =>
      _WordExplanationModalViewState();
}

class _WordExplanationModalViewState extends State<WordExplanationModalView> {
  static const int expansionPanelsCount = 3;
  static const expansionPanelHeight = 57;
  static const bottomExpansionPanelsCount = expansionPanelsCount - 1;
  static const bottomExpansionPanelsHeight =
      ((bottomExpansionPanelsCount * expansionPanelHeight) - 100) / 100;

  static const _backgroundColor = Color.fromARGB(255, 244, 246, 250);

  late final PageController _definitionsPageController;

  late final BehaviorSubject<double> _topAreaSweepingOffset;

  @override
  void initState() {
    _topAreaSweepingOffset = BehaviorSubject<double>();
    _definitionsPageController = PageController(
      viewportFraction: 0.85,
    )..addListener(() {
        final page = _definitionsPageController.page!;
        if (page * 100 < ModalTopArea.height) {
          _topAreaSweepingOffset.add(-page * 100);
        } else if (_topAreaSweepingOffset.value != -ModalTopArea.height) {
          _topAreaSweepingOffset.add(-ModalTopArea.height);
        }
      });

    super.initState();
  }

  @override
  void dispose() {
    _topAreaSweepingOffset.close();
    _definitionsPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double explanationCardsPageViewHeight =
        widget.size.height - ModalTopArea.height - expansionPanelHeight;
    final word = widget.text.item1.first.replaceAll(RegExp(r'[^a-zA-Z]'), '');
    return SizedBox(
      height: widget.size.height,
      width: widget.size.width,
      child: Center(
        child: FutureBuilder(
          future: widget.scraper.search(word),
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
              final pos = snapshot.data?[0].pos;
              final mainSenses = snapshot.data![0].main.senses?.toList();
              final idioms = snapshot.data![0].idioms?.toList();
              return StreamBuilder<double>(
                  stream: _topAreaSweepingOffset.stream,
                  builder: (context, snapshot) {
                    final scrollingOffset = snapshot.data ?? 0.0;
                    final modalHeight = widget.size.height +
                        bottomExpansionPanelsHeight * -scrollingOffset;

                    return Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: modalHeight,
                          width: 411,
                          color: _backgroundColor,
                        ),
                        Positioned(
                          top: scrollingOffset,
                          child: ModalTopArea(
                            word: word,
                            pos: pos ?? '',
                          ),
                        ),
                        Positioned(
                          top: ModalTopArea.height + scrollingOffset,
                          child: Container(
                              decoration: const BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color:
                                          Color.fromRGBO(186, 186, 186, 100)),
                                ),
                              ),
                              width: 411,
                              child: ExpansionPanelBuilder(
                                backgroundColor: _backgroundColor,
                                children: [
                                  if (mainSenses != null) ...[
                                    ExpansionPanelItem(
                                      header: const ListTile(
                                        title: Text('Definitions'),
                                      ),
                                      body: DefinitionCardsPageView(
                                        senses: mainSenses,
                                        pageController:
                                            _definitionsPageController,
                                        height: explanationCardsPageViewHeight,
                                      ),
                                    ),
                                  ],
                                  if (idioms != null) ...[
                                    ExpansionPanelItem(
                                      header: const ListTile(
                                        title: Text('Idioms'),
                                      ),
                                      body: IdiomsCardsPageView(
                                        height: explanationCardsPageViewHeight,
                                        idioms: idioms,
                                      ),
                                    )
                                  ],
                                  ExpansionPanelItem(
                                    header: const ListTile(
                                      title: Text('External Links'),
                                    ),
                                    body: Container(),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}

enum ArrowDirection {
  left,
  right,
}
