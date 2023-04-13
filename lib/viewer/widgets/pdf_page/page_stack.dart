import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/word_highlight.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../crud/pdf_to_image_converter/pdf_to_image_converter.dart';
import 'bloc/page_states.dart';

class PageStack extends StatelessWidget {
  const PageStack({
    super.key,
    required this.state,
    required this.onVisibilityChanged,
    required this.size,
    required this.pageNumber,
    required this.pdfToImageConverter,
  });

  final dynamic state;
  final void Function(
      {required VisibilityInfo details,
      required BuildContext context,
      required double width}) onVisibilityChanged;
  final Size size;
  final int pageNumber;
  final PdfToImage pdfToImageConverter;
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
                    File(pdfToImageConverter.cache[pageNumber]!.path),
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
