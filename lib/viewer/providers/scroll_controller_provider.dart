import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScrollControllerModel extends ChangeNotifier {
  static const Duration _animationDuration = Duration(milliseconds: 500);
  final _scrollController = ScrollController();

  bool get hasClients => scrollController.hasClients;
  ScrollController get scrollController => _scrollController;

  // animates the position by an offset
  void animateBy(double offset) {
    scrollController.animateTo(
      scrollController.offset + offset,
      duration: _animationDuration,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}

final scrollControllerProvider =
    ChangeNotifierProvider((ref) => ScrollControllerModel());
