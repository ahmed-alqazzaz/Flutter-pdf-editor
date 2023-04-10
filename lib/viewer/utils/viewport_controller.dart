import 'dart:async';
import 'package:flutter/widgets.dart';
import '../widgets/pdf_page/bloc/page_events.dart';
import '../widgets/pdf_page/bloc/page_states.dart';
import '../widgets/pdf_page/pdf_page.dart';

class ViewportController {
  ViewportController();
  Timer? _vieweportUpdatingTimer;

  void updateViewport({
    required final double scaleFactor,
    required final Map<int, GlobalKey<PdfPageState>> pdfPageKeys,
  }) {
    _vieweportUpdatingTimer?.cancel();
    _vieweportUpdatingTimer = Timer(
      const Duration(milliseconds: 300),
      () {
        for (int pageNumber = 0;
            pageNumber < pdfPageKeys.length;
            pageNumber++) {
          final pdfPageState = pdfPageKeys[pageNumber]?.currentState;
          final pdfPageBloc = pdfPageState?.bloc;
          final pdfPageVisibleBounds = pdfPageState?.pageVisibleBounds;
          if (pdfPageState != null &&
              pdfPageBloc != null &&
              pdfPageVisibleBounds != null) {
            final blocState = pdfPageBloc.state;
            pdfPageBloc.add(
              PageEventUpdateDisplay(
                pageVisibleBounds: pdfPageVisibleBounds,
                pageNumber: pageNumber,
                scaleFactor: scaleFactor,
                extractedText: blocState is PageStateUpdatingDisplay
                    ? blocState.extractedText
                    : null,
              ),
            );
          } else {
            print(pdfPageState);
            print(pdfPageBloc);
            print(pdfPageVisibleBounds);
          }
        }
      },
    );
  }
}
