import '../crud/text_recognizer.dart';

abstract class PageEvent {
  const PageEvent();
}

class PageEventInitial extends PageEvent {
  const PageEventInitial();
}

class PageEventUpdateDisplay extends PageEvent {
  PageEventUpdateDisplay({
    required this.pageNumber,
    required this.scaleFactor,
    required this.extractedText,
  });

  final int pageNumber;
  final double scaleFactor;
  WordCollection? extractedText;
}
