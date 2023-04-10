import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page_gesture_detector/pdf_page_gesture_detector.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/word_highlight.dart';

import 'package:visibility_detector/visibility_detector.dart';

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
    PdfToImage().resetCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pdfPage = PdfToImage().cache[widget.pageNumber];
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
        create: (context) => PageBloc(),
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
              ),
            );
          },
        ),
      ),
    );
  }
}

class PageStack extends StatelessWidget {
  const PageStack({
    super.key,
    required this.state,
    required this.onVisibilityChanged,
    required this.size,
    required this.pageNumber,
  });

  final dynamic state;
  final void Function(
      {required VisibilityInfo details,
      required BuildContext context,
      required double width}) onVisibilityChanged;
  final Size size;
  final int pageNumber;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // transition between old lower resolution images to higher quality ones
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 800),
          transitionBuilder: (child, animation) {
            return FadeTransition(
              alwaysIncludeSemantics: true,
              opacity: Tween(begin: 0.7, end: 1.0).animate(animation),
              child: child,
            );
          },
          child: VisibilityDetector(
            key: UniqueKey(),
            onVisibilityChanged: (info) => onVisibilityChanged(
              context: context,
              details: info,
              width: size.width,
            ),
            child: state is PageStateUpdatingDisplay
                ? Stack(
                    children: [
                      RawImage(
                        image: state.mainImage,
                        fit: BoxFit.fill,
                        width: size.width,
                        height: size.height,
                        key: UniqueKey(),
                      ),
                      if (state.highResolutionPatch != null) ...[
                        Positioned(
                          width: state.highResolutionPatch!.details.width /
                              state.scaleFactor,
                          height: state.highResolutionPatch!.details.height /
                              state.scaleFactor,
                          left: state.highResolutionPatch!.details.left /
                              state.scaleFactor,
                          top: state.highResolutionPatch!.details.top /
                              state.scaleFactor,
                          child: RawImage(
                            image: state.highResolutionPatch!.image,
                            fit: BoxFit.fill,
                            width: state.highResolutionPatch!.details.width,
                            height: state.highResolutionPatch!.details.height,
                            key: UniqueKey(),
                          ),
                        )
                      ],
                    ],
                  )
                : // use cached image
                Image.file(
                    File(PdfToImage().cache[pageNumber]!.path),
                    fit: BoxFit.fill,
                    width: size.width,
                    height: size.height,
                    key: UniqueKey(),
                  ),
          ),
        ),
        const WordHighlight(),
      ],
    );
  }
}
