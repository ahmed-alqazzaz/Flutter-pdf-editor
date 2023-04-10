import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/bloc/page_events.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/bloc/page_states.dart';

import '../../../crud/pdf_to_image_converter/pdf_to_image_converter.dart';

import 'data.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  static const extractedTextScaleFactor = 4;
  PageBloc() : super(const PageStateInitial()) {
    on<PageEventUpdateDisplay>(
      (event, emit) async {
        final x = Stopwatch()..start();
        final mainImage = await PdfToImage().getOrUpdateImage(
          pageNumber: event.pageNumber,
          scaleFactor: 3,
        );
        HighResolutionPatch? highResolutionPatch;
        if (event.scaleFactor > 3) {
          highResolutionPatch = HighResolutionPatch(
            image: await PdfToImage().createImage(
              pageNumber: event.pageNumber,
              scaleFactor: event.scaleFactor,
              pageCropRect: event.pageVisibleBounds,
            ),
            details: event.pageVisibleBounds,
          );
        }
        print("lasted: ${x.elapsedMilliseconds}");

        emit(
          PageStateUpdatingDisplay(
            scaleFactor: event.scaleFactor,
            mainImage: await decodeImageFromList(
              File(mainImage.path).readAsBytesSync(),
            ),
            highResolutionPatch: highResolutionPatch,
            // generate wordcollection only when scaleFactor is 4 or above
            // and it has not been generated before

            extractedText: mainImage.scaleFactor >= 4
                ? event.extractedText ??
                    await TextRecognizer()
                        .processImage(InputImage.fromFilePath(mainImage.path))
                : null,
          ),
        );
      },
    );
  }
}
