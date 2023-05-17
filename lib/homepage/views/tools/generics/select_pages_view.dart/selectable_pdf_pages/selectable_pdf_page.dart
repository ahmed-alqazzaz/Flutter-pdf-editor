import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_editor/homepage/views/generics/selectable/selectable.dart';

class SelectablePdfPage extends StatelessWidget {
  SelectablePdfPage({
    required this.imagePath,
    required this.index,
    super.key,
  });

  final String imagePath;
  final int index;
  static const double aspectRatio = 0.85;
  static const double indexBoxCircularPadding = 3;
  static const double indexBoxOpacity = 0.6;
  static const Color indexBoxColor = Colors.black54;
  static const Color indexBoxTextColor = Colors.white;
  static const double selectionOverlayOpacity = 0.4;
  static const double indexBoxMaxheight = 20;
  static const double indexBoxMaxWidth = 50;
  final selectionOverlayColor = Colors.blue.shade900;

  Widget indexBox() {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: indexBoxMaxheight,
        maxWidth: indexBoxMaxWidth,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(indexBoxCircularPadding),
        color: indexBoxColor.withOpacity(indexBoxOpacity),
      ),
      child: Center(
        child: Text(
          index.toString(),
          style: const TextStyle(color: indexBoxTextColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Selectable(
              index: index,
              selectionOverlayColor: selectionOverlayColor,
              selectionOverlayOpacity: selectionOverlayOpacity,
              child: Image.file(
                File(imagePath),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              right: constraints.maxWidth / 3,
              left: constraints.maxWidth / 3,
              child: Center(
                child: indexBox(),
              ),
            ),
          ],
        );
      },
    );
  }
}
