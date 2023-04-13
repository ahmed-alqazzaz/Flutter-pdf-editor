import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/viewer/utils/get_args.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/page_stack.dart';

import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page_gesture_detector/pdf_page_gesture_detector.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/word_highlight.dart';

import 'package:flutter_mupdf/flutter_mupdf.dart' as mu;
import 'package:visibility_detector/visibility_detector.dart';

import '../../../bloc/app_bloc.dart';
import '../../providers/word_interaction_provider.dart';
import 'bloc/page_bloc.dart';
import 'bloc/page_states.dart';
import '../../crud/pdf_to_image_converter/pdf_to_image_converter.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({
    super.key,
    required this.pageNumber,
  });

  final int pageNumber;

  @override
  State<PdfPage> createState() => PdfPageState();
}

class PdfPageState extends State<PdfPage> {
  PdfToImage get pdfToImageConverter => context.getArgument<PdfToImage>()!;
  PageBloc? bloc;
  Timer? visibilityChangeTimer;
  Rect? pageVisibleBounds;

  void onPageVisibilityChanges({
    required BuildContext context,
    required VisibilityInfo details,
    required double width,
  }) {
    if (details.visibleBounds.right != 0 &&
        details.visibleBounds.bottom != 0 &&
        details.visibleBounds != pageVisibleBounds) {
      // viewportController updates its value 300 milliseconds
      // after visibilityChange is triggered so timer is necessary
      // to prevent using old viewport
      visibilityChangeTimer?.cancel();
      visibilityChangeTimer = Timer(const Duration(milliseconds: 50), () {
        pageVisibleBounds = details.visibleBounds;
      });
    }
  }

  @override
  void dispose() {
    pdfToImageConverter.resetCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pdfPage = pdfToImageConverter.cache[widget.pageNumber];
    if (pdfPage == null) {
      return Container();
    }
    final pdfPageSize = pdfPage.size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenToPdfWidthRatio = screenWidth / pdfPageSize.width;
    final height = pdfPageSize.height * screenToPdfWidthRatio;
    return ProviderScope(
      overrides: [
        // Override is necessary to avoid overlap with
        // other pages that are also visible
        wordInteractionProvider.overrideWith(
          (ref) => WordInteractionModel(),
        )
      ],
      child: BlocProvider(
        create: (context) => PageBloc(pdfToImageConverter),
        child: BlocBuilder<PageBloc, PageState>(
          builder: (context, state) {
            bloc = context.read<PageBloc>();
            return PdfPageGestureDetector(
              scaleFactor:
                  state is PageStateUpdatingDisplay ? state.scaleFactor : 1,
              extractedText: state is PageStateUpdatingDisplay
                  ? state.extractedText
                  : null,
              pdfPageWidth: pdfPageSize.width,
              child: PageStack(
                key: UniqueKey(),
                state: state,
                onVisibilityChanged: onPageVisibilityChanges,
                pageNumber: widget.pageNumber,
                size: Size(screenWidth, height),
                pdfToImageConverter: pdfToImageConverter,
              ),
            );
          },
        ),
      ),
    );
  }
}
