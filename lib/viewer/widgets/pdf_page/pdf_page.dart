import 'dart:async';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page_gesture_detector/pdf_page_gesture_detector.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/word_highlight.dart';

import 'package:visibility_detector/visibility_detector.dart';

import '../../providers/pdf_viewer_related/word_interaction_provider.dart';
import 'bloc/page_bloc.dart';
import 'bloc/page_states.dart';
import '../../crud/pdf_to_image_converter/pdf_to_image_converter.dart';

class PdfPageView extends StatefulWidget {
  const PdfPageView({
    super.key,
    required this.pageNumber,
    required this.pdfToImageConverter,
  });

  final int pageNumber;
  final PdfToImage pdfToImageConverter;
  @override
  State<PdfPageView> createState() => PdfPageViewState();
}

class PdfPageViewState extends State<PdfPageView> {
  PageBloc? bloc;

  Timer? visibilityChangeTimer;
  Rect? pageVisibleBounds;

  @override
  void didChangeDependencies() {
    bloc = context.read<PageBloc>();
    super.didChangeDependencies();
  }

  void _onPageVisibilityChanges({
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
    bloc?.close();
    widget.pdfToImageConverter.resetCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pdfPage = widget.pdfToImageConverter.cache[widget.pageNumber];
    final pdfPageSize = widget.pdfToImageConverter.pageSize;
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
      child: BlocBuilder<PageBloc, PageState>(
        builder: (context, state) {
          if (pdfPage == null || state is PageStateDisplayBlank) {
            return SizedBox(
              width: screenWidth,
              height: height,
            );
          }
          return PdfPageGestureDetector(
            scaleFactor: state is PageStateDisplayMain ? state.scaleFactor : 1,
            extractedText:
                state is PageStateDisplayMain ? state.extractedText : null,
            pdfPageWidth: pdfPageSize.width,
            child: // transition from cached to main image
                Stack(
              children: [
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
                    onVisibilityChanged: (info) => _onPageVisibilityChanges(
                      context: context,
                      details: info,
                      width: screenWidth,
                    ),
                    child: state is PageStateDisplayMain
                        ? Stack(
                            children: [
                              RawImage(
                                image: state.mainImage,
                                fit: BoxFit.fill,
                                width: screenWidth,
                                height: height,
                                key: UniqueKey(),
                              ),
                              if (state.highResolutionPatch != null) ...[
                                Positioned(
                                  width:
                                      state.highResolutionPatch!.details.width /
                                          state.scaleFactor,
                                  height: state
                                          .highResolutionPatch!.details.height /
                                      state.scaleFactor,
                                  left:
                                      state.highResolutionPatch!.details.left /
                                          state.scaleFactor,
                                  top: state.highResolutionPatch!.details.top /
                                      state.scaleFactor,
                                  child: RawImage(
                                    image: state.highResolutionPatch!.image,
                                    fit: BoxFit.fill,
                                    width: state
                                        .highResolutionPatch!.details.width,
                                    height: state
                                        .highResolutionPatch!.details.height,
                                    key: UniqueKey(),
                                  ),
                                )
                              ],
                            ],
                          )
                        : // use cached image
                        Image.file(
                            File(widget.pdfToImageConverter
                                .cache[widget.pageNumber]!.path),
                            fit: BoxFit.fill,
                            width: screenWidth,
                            height: height,
                            key: UniqueKey(),
                          ),
                  ),
                ),
                const WordHighlight(),
              ],
            ),
          );
        },
      ),
    );
  }
}
