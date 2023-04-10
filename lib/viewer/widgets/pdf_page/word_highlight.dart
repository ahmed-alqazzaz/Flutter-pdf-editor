import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/word_interaction_provider.dart';

class WordHighlight extends ConsumerWidget {
  const WordHighlight({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordBoundingBox = ref.watch(wordInteractionProvider).wordBoundingBox;
    if (wordBoundingBox != null) {
      return Positioned(
        top: wordBoundingBox.top,
        left: wordBoundingBox.left,
        child: Opacity(
          opacity: 0.5,
          child: SizedBox(
            height: wordBoundingBox.height,
            width: wordBoundingBox.width,
            child: DecoratedBox(
              decoration: BoxDecoration(color: Colors.orange.shade900),
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }
}
