import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/oxford_dictionary_scraper/data/data.dart';

class WordExplanationController extends ChangeNotifier {
  WordExplanationController([List<Future<Lexicon>>? words]) : _words = words;
  int _selectedWordIndex = 0;
  final List<Future<Lexicon>>? _words;

  List<Future<Lexicon>> get words => _words!;
  int get selectedWordIndex => _selectedWordIndex;

  void updateSelectedWord(final int selectedWordIndex) {
    if (selectedWordIndex >= words.length) {
      throw const SelectedWordIndexIsOutOfRange();
    }
    _selectedWordIndex = selectedWordIndex;

    notifyListeners();
  }
}

final wordExplanationProvider =
    ChangeNotifierProvider((ref) => WordExplanationController());

@immutable
class SelectedWordIndexIsOutOfRange implements Exception {
  const SelectedWordIndexIsOutOfRange();
}
