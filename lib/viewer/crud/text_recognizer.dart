import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<WordCollection> wordCollectionExtractor({
  required String imageFilePath,
  required double scaleFactor,
}) =>
    TextRecognizer().processImage(InputImage.fromFilePath(imageFilePath)).then(
          (value) => WordCollection(
            scaleFactor: scaleFactor,
            lines: value.blocks
                .map(
                  (block) => block.lines.map(
                    (line) => Line(
                      words: line.elements.map(
                        (element) {
                          final boundingBox = element.boundingBox;
                          return Word(
                            text: element.text,
                            position: Position(
                              top: boundingBox.top / scaleFactor,
                              bottom: boundingBox.bottom / scaleFactor,
                              left: boundingBox.left / scaleFactor,
                              right: boundingBox.right / scaleFactor,
                            ),
                            dimensions: Dimensions(
                              width: boundingBox.width / scaleFactor,
                              height: boundingBox.height / scaleFactor,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ) // expand the iterable of iterables into a main iterable
                .expand((element) => element),
          ),
        );

@immutable
class WordCollection {
  const WordCollection({
    required this.lines,
    required this.scaleFactor,
  });
  final Iterable<Line> lines;
  final double scaleFactor;
}

@immutable
class Line {
  const Line({required this.words});
  final Iterable<Word> words;
}

@immutable
class Word {
  const Word({
    required this.position,
    required this.text,
    required this.dimensions,
  });
  final String text;
  final Position position;
  final Dimensions dimensions;
  bool isGestureWithinRange(Offset location, double scaleFactor) {
    if (location.dx >= position.left &&
        location.dx <= position.right &&
        location.dy >= position.top &&
        location.dy <= position.bottom) {
      return true;
    }
    return false;
  }
}

@immutable
class Position {
  const Position({
    required this.top,
    required this.bottom,
    required this.left,
    required this.right,
  });
  final double top;
  final double bottom;
  final double left;
  final double right;
}

class Dimensions {
  Dimensions({
    required this.width,
    required this.height,
  });
  final double width;
  final double height;
}
