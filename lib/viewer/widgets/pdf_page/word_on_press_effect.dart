import 'dart:async';

import 'package:flutter/material.dart';

import '../../crud/text_recognizer.dart';

class WordOnPressEffect extends StatelessWidget {
  const WordOnPressEffect({super.key, required this.pressedWordController});
  final StreamController<Word?> pressedWordController;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: pressedWordController.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          final word = snapshot.data!;
          return Positioned(
            top: word.position.top,
            left: word.position.left,
            child: Opacity(
              opacity: 0.5,
              child: SizedBox(
                height: word.dimensions.height,
                width: word.dimensions.width,
                child: const DecoratedBox(
                  decoration: BoxDecoration(color: Colors.lightGreenAccent),
                ),
              ),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
