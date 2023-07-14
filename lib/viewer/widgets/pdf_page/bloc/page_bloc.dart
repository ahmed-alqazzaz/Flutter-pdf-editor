import 'dart:async';
import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:pdf_editor/pdf_renderer/renderer.dart';
import 'package:pdf_editor/pdf_renderer/rust_pdf_renderer/decode_rust_image.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/bloc/page_events.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/bloc/page_states.dart';
import 'data.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  PageBloc(this.renderer) : super(const PageStateDisplayBlank()) {
    _cacheTimer = Timer(_displayingBlankDuration, () {
      add(const PageEventDisplayCache());
    });

    on<PageEventDisplayCache>(
      (event, emit) => emit(const PageStateDisplayCache()),
    );

    on<PageEventDisplayMain>(
      (event, emit) async {
        final timer = Stopwatch()..start();
        final mainPageImage = await renderer.renderImage(
          pageNumber: event.pageNumber,
          scaleFactor: 1,
        );
        final mainImage = await mainPageImage.decodeImage();

        HighResolutionPatch? highResolutionPatch;
        // TODO: render high resolution patch
        if (event.scaleFactor > 1 && false) {
          log(event.pageVisibleBounds.toString());
          //await RustPdfRenderer.instance().cacheAllPages();
          final rustPageImage = await renderer.renderImage(
              pageNumber: event.pageNumber - 1,
              scaleFactor: event.scaleFactor * (1),
              pageCropRect: Rect.fromLTWH(
                event.pageVisibleBounds.left / event.scaleFactor,
                event.pageVisibleBounds.top / event.scaleFactor,
                event.pageVisibleBounds.width / event.scaleFactor,
                event.pageVisibleBounds.height / event.scaleFactor,
              ));
          final renderImage = await rustPageImage.decodeImage();
          log("requested rect ${event.pageVisibleBounds}");
          log("printed rect: ${rustPageImage.renderRect}");

          // final image = await rustPageImage.decodeImage();
          // log("rust width: ${image.width}");
          // log("rust height: ${image.height}");

          highResolutionPatch = HighResolutionPatch(
            image: renderImage,
            details: Rect.fromLTWH(
              (rustPageImage.renderRect.left) * (1),
              (rustPageImage.renderRect.top) * (1),
              (rustPageImage.renderRect.width) * (1),
              (rustPageImage.renderRect.height) * (1),
            ),
          );
        }
        log("lasted: ${timer.elapsedMilliseconds}");

        emit(
          PageStateDisplayMain(
            scaleFactor: event.scaleFactor,
            mainImage: mainImage,
            highResolutionPatch: highResolutionPatch,
            extractedText: event.extractedText,
          ),
        );
        if (event.extractedText == null && state is PageStateDisplayMain) {
          final timer = Stopwatch()..start();
          await TextRecognizer()
              .processImage(
            InputImage.fromFilePath(renderer.cache[event.pageNumber].path),
          )
              .then(
            (recognizedText) {
              log("recognized text within ${timer.elapsedMilliseconds}");
              emit((state as PageStateDisplayMain).copyWith(
                extractedText: recognizedText,
              ));
            },
          );
        }
      },
    );
  }

  static const Duration _displayingBlankDuration = Duration(milliseconds: 300);
  final PdfRenderer renderer;
  static const cachedPageWidth = 480;
  static const mainPageWidth = 1080;

  Timer? _cacheTimer;

  @override
  Future<void> close() {
    _cacheTimer?.cancel();
    return super.close();
  }
}
