import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rxdart/rxdart.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../bloc/page_bloc.dart';
import '../bloc/page_events.dart';
import '../bloc/page_states.dart';
import '../crud/pdf_to_image_converter.dart';

class PdfPage extends StatelessWidget {
  const PdfPage({
    super.key,
    required this.pageNumber,
    required this.scaleLevel,
  });
  final int pageNumber;
  final BehaviorSubject<double> scaleLevel;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PageBloc(),
      child: PageStack(
        pageNumber: pageNumber,
        scaleLevel: scaleLevel,
      ),
    );
  }
}

class PageStack extends StatefulWidget {
  const PageStack({
    super.key,
    required this.pageNumber,
    required this.scaleLevel,
  });
  final int pageNumber;
  final BehaviorSubject<double> scaleLevel;
  @override
  State<PageStack> createState() => _PageStackState();
}

class _PageStackState extends State<PageStack> {
  Timer? scaleFactorTimer;
  late final StreamSubscription<double> scaleSubscription;
  late final BehaviorSubject<bool> isPageOnView;
  @override
  void initState() {
    isPageOnView = BehaviorSubject<bool>();
    // increase scaleFactor(resolution) after 3 seconds

    scaleFactorTimer = Timer(const Duration(milliseconds: 1500), () {
      final pageBloc = context.read<PageBloc>();
      final state = pageBloc.state;
      pageBloc.add(
        PageEventUpdateDisplay(
          pageNumber: widget.pageNumber,
          scaleFactor: 3,
          extractedText:
              state is PageStateUpdatingDisplay ? state.extractedText : null,
        ),
      );
    });
    scaleSubscription =
        widget.scaleLevel.stream.distinct().listen((zoomLevel) async {
      final state = context.read<PageBloc>().state;
      // update page resolution when zoom level changes
      if (zoomLevel >= 3 && isPageOnView.valueOrNull == true) {
        scaleFactorTimer?.cancel();

        scaleFactorTimer = Timer(const Duration(milliseconds: 300), () {
          context.read<PageBloc>().add(
                PageEventUpdateDisplay(
                  pageNumber: widget.pageNumber,
                  scaleFactor: zoomLevel,
                  extractedText: state is PageStateUpdatingDisplay
                      ? state.extractedText
                      : null,
                ),
              );
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    scaleFactorTimer?.cancel();
    scaleSubscription.cancel();
    //  isPageOnView.close();
    PdfToImage().resetCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageDimension = PdfToImage().pdfDimensions;

    return BlocBuilder<PageBloc, PageState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {},
          onTapDown: (details) {
            if (state is PageStateUpdatingDisplay &&
                state.extractedText != null) {
              for (final line in state.extractedText!.lines) {
                for (final word in line.words) {
                  if (word.isGestureWithinRange(details.localPosition,
                      state.extractedText!.scaleFactor)) {
                    print(word.text);
                  }
                }
              }
            }
          },
          child: Stack(
            children: [
              // transition between old lower resolution images to higher quality ones
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    alwaysIncludeSemantics: true,
                    opacity: Tween(begin: 0.7, end: 1.0).animate(animation),
                    child: child,
                  );
                },
                child: VisibilityDetector(
                  key: UniqueKey(),
                  onVisibilityChanged: (details) async {
                    if (widget.scaleLevel.hasValue) {
                      // general page visibility fraction (same irregardless of zoom)
                      // is the page visibility fraction when zoom level (scale level) is 1
                      // multiplied by the zoom level squared
                      // and in case page width is larger than the render object (zoom > 1):
                      // it's multiplied by pdf page to screen page size ratio
                      final size = MediaQueryData.fromWindow(
                              WidgetsBinding.instance.window)
                          .size;
                      final screenSize = size.width * size.height;
                      final pdfPageSize =
                          (pageDimension.width * pageDimension.height);
                      final pageToScreenRatio = pdfPageSize / screenSize;

                      final pageVisibleFraction = details.visibleFraction *
                          pow(widget.scaleLevel.value, 2) *
                          (details.size.width > size.width
                              ? pageToScreenRatio
                              : 1);

                      // TODO: check for appbar
                      // REMINDER: i added 0.1 because the app bar was taking 10% of the window
                      if (pageVisibleFraction + 0.1 > 0.9) {
                        isPageOnView.sink.add(true);
                      } else {
                        isPageOnView.sink.add(false);
                      }
                    }
                  },
                  child: state is PageStateUpdatingDisplay // use cached image
                      ? Image.file(
                          File(PdfToImage().cache[widget.pageNumber]!.path),
                          fit: BoxFit.fill,
                          width: 396,
                          height: 612,
                          key: UniqueKey(),
                        )
                      : Image.file(
                          File(PdfToImage().cache[widget.pageNumber]!.path),
                          fit: BoxFit.fill,
                          width: 396,
                          height: 612,
                          key: UniqueKey(),
                        ),
                ),
              ),

              // if (state is PageStateDisplaying &&
              //     state.extractedText != null) ...[
              //   for (final line in state.extractedText!.lines)
              //     for (final word in line.words)
              //       Positioned(
              //           top: word.position.top / state.extractedText!.scaleFactor,
              //           //bottom: 81,
              //           left:
              //               word.position.left / state.extractedText!.scaleFactor,
              //           child: Opacity(
              //             opacity: 0.5,
              //             child: GestureDetector(
              //               onTap: () {
              //                 print(word.text);
              //               },
              //               child: SizedBox(
              //                 height: word.dimensions.height /
              //                     state.extractedText!.scaleFactor,
              //                 width: word.dimensions.width /
              //                     state.extractedText!.scaleFactor,
              //                 child: const DecoratedBox(
              //                   decoration: BoxDecoration(color: Colors.red),
              //                 ),
              //               ),
              //             ),
              //           )
              //           //right: MediaQuery.of(context).size.width - 63.4,
              //           ),
              // ],
            ],
          ),
        );
      },
    );
  }
}
