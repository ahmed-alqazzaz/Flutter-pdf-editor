import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/viewer/bloc/page_events.dart';
import 'package:pdf_editor/viewer/bloc/page_states.dart';

import '../crud/pdf_to_image_converter.dart';
import '../crud/text_recognizer.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(const PageStateInitial()) {
    on<PageEventUpdateDisplay>(
      (event, emit) async {
        await PdfToImage()
            .getOrUpdateImage(
              pageNumber: event.pageNumber,
              scaleFactor: event.scaleFactor,
            )
            .then(
              (pageImage) async => emit(
                PageStateUpdatingDisplay(
                    pageImage: pageImage,
                    // generate wordcollection only when scaleFactor is 3 or above
                    extractedText: pageImage.scaleFactor >= 3
                        ? event.extractedText ??
                            await wordCollectionExtractor(
                                imageFilePath: pageImage.path,
                                scaleFactor: pageImage.scaleFactor)
                        : null),
              ),
            );
      },
    );
  }
}
