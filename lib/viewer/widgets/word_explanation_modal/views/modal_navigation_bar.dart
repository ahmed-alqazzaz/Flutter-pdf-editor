import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/helpers/extensions/capitalize_string.dart';
import 'package:pdf_editor/viewer/providers/word_explanation_modal_related/word_explanation_provider.dart';

import '../../../../auth/generics/buttons/generic_button.dart';
import '../../../utils/oxford_dictionary_scraper/data/data.dart';

class ExplanationModalNavigationBar extends ConsumerWidget {
  const ExplanationModalNavigationBar({
    super.key,
    required this.body,
    required this.headerWords,
  });
  final Widget body;

  static const double _buttonsPadding = 5;
  static const double height = 50;

  static const Color _selectedButtonBackgroundColor = Colors.deepPurple;
  static const Color _defaultButtonBackgroundColor =
      Color.fromARGB(255, 244, 246, 250);
  static const Color _selectedButtonTextColor = Colors.white;
  static const Color _defaultButtonTextColor = Colors.black;

  final List<dynamic> headerWords;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordExplanationController = ref.watch(wordExplanationProvider);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          height: height,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final headerWord = headerWords[index];
              final headerWordText = () {
                if (headerWord is Lexicon) {
                  return headerWord.word.capitalize();
                } else if (headerWord is SimilarWord) {
                  return headerWord.text.capitalize();
                } else if (headerWord is PhrasalVerb) {
                  return headerWord.text.capitalize();
                }
                throw UnimplementedError();
              }();
              final headerWordPos = () {
                if (headerWord is Lexicon) {
                  return '(${headerWord.pos}';
                } else if (headerWord is SimilarWord) {
                  return '(${headerWord.pos})';
                } else if (headerWord is PhrasalVerb) {
                  return '(${headerWord.pos})';
                }
                throw UnimplementedError();
              }();

              return GenericButtonn(
                onPressed: () {
                  wordExplanationController.updateSelectedWord(index);
                },
                backgroundColor: MaterialStateProperty.all(
                  wordExplanationController.selectedWordIndex == index
                      ? _selectedButtonBackgroundColor
                      : _defaultButtonBackgroundColor,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                border: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Row(
                  children: [
                    Text(
                      headerWordText,
                      style: TextStyle(
                        fontSize: 15,
                        color:
                            wordExplanationController.selectedWordIndex == index
                                ? _selectedButtonTextColor
                                : _defaultButtonTextColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5, top: 2),
                      child: Text(
                        headerWordPos,
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 10,
                          color: wordExplanationController.selectedWordIndex ==
                                  index
                              ? _selectedButtonTextColor
                              : _defaultButtonTextColor,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(
              width: _buttonsPadding,
            ),
            itemCount: headerWords.length,
          ),
        ),
        Expanded(child: body),
      ],
    );
  }
}
