import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/generics/selectable/selectability_provider.dart';

class Selectable extends ConsumerWidget {
  const Selectable({
    super.key,
    required this.child,
    required this.index,
    required this.selectionOverlayColor,
    required this.selectionOverlayOpacity,
  });

  final Widget child;
  final int index;
  final double selectionOverlayOpacity;
  final Color selectionOverlayColor;
  Widget selectionSplash(SelectabilityModel selectabilityModel) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        overlayColor: MaterialStatePropertyAll(selectionOverlayColor),
        onHighlightChanged: (isHighlightPresent) {
          if (!isHighlightPresent) {
            // display\hide blue highlight after inkwell splash dissapears
            selectabilityModel.onTap(index);
          }
        },
        onTap: () {},
      ),
    );
  }

  Widget selectionHighlight(BoxConstraints constraints, bool isSelected) {
    return AnimatedOpacity(
      opacity: isSelected ? selectionOverlayOpacity : 0,
      curve: Curves.easeIn,
      duration: const Duration(milliseconds: 200),
      child: Container(
        color: selectionOverlayColor,
        width: constraints.maxWidth,
        height: constraints.maxHeight,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSelected = ref.watch(
      selectabilityProvider.select(
        (value) => value.selectedIndexes.contains(index),
      ),
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            child,
            selectionHighlight(constraints, isSelected),
            Positioned.fill(
              child: selectionSplash(ref.read(selectabilityProvider)),
            ),
          ],
        );
      },
    );
  }
}
