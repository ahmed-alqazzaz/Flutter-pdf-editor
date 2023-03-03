import 'package:equatable/equatable.dart';

import '../crud/pdf_to_image_converter.dart';
import '../crud/text_recognizer.dart';

abstract class PageState extends Equatable {
  const PageState();
  @override
  List<Object?> get props => [];
}

class PageStateInitial extends PageState {
  const PageStateInitial();
}

class PageStateUpdatingDisplay extends PageState {
  const PageStateUpdatingDisplay({
    required this.pageImage,
    this.extractedText,
  });

  final PageImage pageImage;
  final WordCollection? extractedText;

  @override
  List<Object?> get props => [pageImage, extractedText];
}
