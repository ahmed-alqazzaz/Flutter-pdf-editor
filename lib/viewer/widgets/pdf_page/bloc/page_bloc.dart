import 'dart:async';
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
  PageBloc(this.pdfToImageConverter) : super(const PageStateDisplayBlank()) {
    _cacheTimer = Timer(_displayingBlankDuration, () {
      add(const PageEventDisplayCache());
    });

    on<PageEventDisplayCache>(
      (event, emit) => emit(const PageStateDisplayCache()),
    );

    on<PageEventDisplayMain>(
      (event, emit) async {
        final timer = Stopwatch()..start();
        final mainImage = await pdfToImageConverter.getOrUpdateImage(
          pageNumber: event.pageNumber,
          scaleFactor: extractedTextScaleFactor,
        );
        HighResolutionPatch? highResolutionPatch;
        if (event.scaleFactor > 3) {
          highResolutionPatch = HighResolutionPatch(
            image: await pdfToImageConverter.createImage(
              pageNumber: event.pageNumber,
              scaleFactor: event.scaleFactor,
              pageCropRect: event.pageVisibleBounds,
            ),
            details: event.pageVisibleBounds,
          );
        }
        log("lasted: ${timer.elapsedMilliseconds}");

        emit(
          PageStateDisplayMain(
            scaleFactor: event.scaleFactor,
            mainImage: await decodeImageFromList(
              File(mainImage.path).readAsBytesSync(),
            ),
            highResolutionPatch: highResolutionPatch,
            // generate wordcollection only when scaleFactor is 4 or above
            // and it has not been generated before

            extractedText: mainImage.scaleFactor >= extractedTextScaleFactor
                ? event.extractedText ??
                    await TextRecognizer().processImage(
                      InputImage.fromFilePath(mainImage.path),
                    )
                : null,
          ),
        );
      },
    );
  }

  static const double extractedTextScaleFactor = 4.0;
  static const Duration _displayingBlankDuration = Duration(milliseconds: 300);

  final PdfToImage pdfToImageConverter;

  Timer? _cacheTimer;

  @override
  Future<void> close() {
    _cacheTimer?.cancel();
    return super.close();
  }
}
