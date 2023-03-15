import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/bloc/page_events.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/bloc/page_states.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page.dart';

import '../../../crud/pdf_to_image_converter.dart';
import '../../../crud/text_recognizer.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc() : super(const PageStateInitial()) {
    on<PageEventUpdateDisplay>(
      (event, emit) async {
        final x = Stopwatch()..start();

        final mainImage = await PdfToImage().getOrUpdateImage(
          pageNumber: event.pageNumber,
          scaleFactor: 3,
        );
        HighResolutionPatch? highResolutionPatch;
        print(event.scaleFactor);
        if (event.scaleFactor > 3) {
          highResolutionPatch = await PdfToImage()
              .createImage(
                pageNumber: 3,
                scaleFactor: event.scaleFactor,
                pageCropRect: event.pageVisibleBounds,
              )
              .then((image) => HighResolutionPatch(
                    image: image,
                    details: event.pageVisibleBounds,
                  ));

          print("lasted: ${x.elapsedMilliseconds}");
        }

        emit(
          PageStateUpdatingDisplay(
            scaleFactor: event.scaleFactor,
            mainImage: await decodeImageFromList(
                File(mainImage.path).readAsBytesSync()),
            highResolutionPatch: highResolutionPatch,

            // generate wordcollection only when scaleFactor is 3 or above
            extractedText: mainImage.scaleFactor >= 3
                ? event.extractedText ??
                    await wordCollectionExtractor(
                        imageFilePath: mainImage.path,
                        scaleFactor: mainImage.scaleFactor)
                : null,
          ),
        );
      },
    );
  }
}
