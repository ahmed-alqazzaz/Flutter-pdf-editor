import 'dart:async';

import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/viewer/crud/text_recognizer.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page_gesture_detector/pdf_page_gesture_detector.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/word_on_press_effect.dart';

import 'package:rxdart/rxdart.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'bloc/page_bloc.dart';
import 'bloc/page_events.dart';
import 'bloc/page_states.dart';
import '../../crud/pdf_to_image_converter.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({
    super.key,
    required this.pageNumber,
    required this.viewportController,
    required this.appBarsVisibilityController,
  });
  final int pageNumber;
  final BehaviorSubject<Matrix4> viewportController;
  final BehaviorSubject<bool> appBarsVisibilityController;

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  late final BehaviorSubject<Word?> _pressedWordsController;
  StreamSubscription<Matrix4>? _viewportSubscription;
  Timer? scaleFactorTimer;
  Timer? visibilityChangeTimer;
  bool _isPageOnView = false;
  Rect? _pageVisibleBounds;

  void onPageVisibilityChanges(
    BuildContext context,
    VisibilityInfo details,
    double width,
  ) {
    if (details.visibleBounds.right != 0 && details.visibleBounds.bottom != 0) {
      // viewportController updates its value 300 milliseconds
      // after visibilityChange is triggered so timer is necessary
      // to prevent using old viewport

      visibilityChangeTimer?.cancel();
      visibilityChangeTimer = Timer(
        const Duration(milliseconds: 50),
        () {
          _pageVisibleBounds = details.visibleBounds;
          if (widget.viewportController.hasValue) {
            final scaleFactor =
                widget.viewportController.value.getMaxScaleOnAxis();

            // in case viewport controller and visibility detector are'nt synchronized
            if (details.size.width / scaleFactor != width) {
              return onPageVisibilityChanges(context, details, width);
            }
            //dev.log("hhh ${(details.size.width / scaleFactor).toString()}");
            // general page visibility fraction (same irregardless of zoom)
            // is the page visibility fraction when zoom level (scale level) is 1
            // multiplied by the zoom level squared
            // and in case page width is larger than the render object (zoom > 1):
            // it's multiplied by pdf page to screen page size ratio
            final pageDimension =
                PdfToImage().cache[widget.pageNumber]!.initialDimensions;
            final size =
                MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
            final screenSize = size.width * size.height;
            final pdfPageSize = (pageDimension.width * pageDimension.height);
            final pageToScreenRatio = pdfPageSize / screenSize;

            final pageVisibleFraction = details.visibleFraction *
                pow(scaleFactor, 2) *
                (details.size.width > size.width ? pageToScreenRatio : 1);

            // TODO: check for appbar
            // REMINDER: i added 0.1 because the app bar was taking 10% of the window
            dev.log("${pageVisibleFraction.toString()} ${widget.pageNumber}");
            if (pageVisibleFraction + 0.1 > 0.7) {
              _isPageOnView = true;
            } else {
              _isPageOnView = false;
            }
          }
        },
      );
    }
  }

  @override
  void initState() {
    // rename to highlightController
    _pressedWordsController = BehaviorSubject<Word?>();
    scaleFactorTimer = Timer(const Duration(milliseconds: 1500), () {
      // when viewport in less than 1.5 seconds after
      // initstate executes, the subscription won't be able
      // to listen to viewport changes prior to its creation causing
      // the state to be stuck so adding the last viewport, if available,
      // is necessary to trigger the listener
      if (widget.viewportController.hasValue) {
        // timer is necessary to ensure subscription is creted before
        // adding the the last viewport
        Timer(const Duration(milliseconds: 40), () {
          widget.viewportController.add(widget.viewportController.value);
        });
      }
      _viewportSubscription =
          widget.viewportController.stream.listen((viewport) async {
        final state = context.read<PageBloc>().state;
        if (_isPageOnView) {
          dev.log("page on view");
          scaleFactorTimer?.cancel();
          scaleFactorTimer = Timer(const Duration(milliseconds: 300), () {
            context.read<PageBloc>().add(
                  PageEventUpdateDisplay(
                    pageVisibleBounds: _pageVisibleBounds!,
                    pageNumber: widget.pageNumber,
                    scaleFactor: viewport.getMaxScaleOnAxis(),
                    extractedText: state is PageStateUpdatingDisplay
                        ? state.extractedText
                        : null,
                  ),
                );
          });
        } else {
          print("page${widget.pageNumber}not on view ");
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scaleFactorTimer?.cancel();
    _viewportSubscription?.cancel();
    _pressedWordsController.close();
    visibilityChangeTimer?.cancel();
    PdfToImage().resetCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final screenToPdfWidthRation =
        width / PdfToImage().cache[widget.pageNumber]!.initialDimensions.width;

    return BlocBuilder<PageBloc, PageState>(
      builder: (context, state) {
        return PdfPageGestureDetector(
          appBarsVisibilityController: widget.appBarsVisibilityController,
          wordOnPressController: _pressedWordsController,
          extractedText:
              state is PageStateUpdatingDisplay ? state.extractedText : null,
          child: Stack(
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
                  onVisibilityChanged: (info) =>
                      onPageVisibilityChanges(context, info, width),
                  child: state is PageStateUpdatingDisplay
                      ? Stack(
                          children: [
                            RawImage(
                              image: state.mainImage,
                              fit: BoxFit.fill,
                              width: width,
                              key: UniqueKey(),
                            ),
                            if (state.highResolutionPatch != null) ...[
                              Positioned(
                                width:
                                    state.highResolutionPatch!.details.width *
                                        screenToPdfWidthRation /
                                        state.scaleFactor,
                                height:
                                    state.highResolutionPatch!.details.height *
                                        screenToPdfWidthRation /
                                        state.scaleFactor,
                                left: state.highResolutionPatch!.details.left *
                                    screenToPdfWidthRation /
                                    state.scaleFactor,
                                top: state.highResolutionPatch!.details.top *
                                    screenToPdfWidthRation /
                                    state.scaleFactor,
                                child: RawImage(
                                  image: state.highResolutionPatch!.image,
                                  fit: BoxFit.fill,
                                  width:
                                      state.highResolutionPatch!.details.width,
                                  height:
                                      state.highResolutionPatch!.details.height,
                                  key: UniqueKey(),
                                ),
                              )
                            ],
                          ],
                        )
                      : // use cached image
                      Image.file(
                          File(PdfToImage().cache[widget.pageNumber]!.path),
                          fit: BoxFit.fill,
                          width: width,
                          key: UniqueKey(),
                        ),
                ),
              ),
              WordOnPressEffect(
                pressedWordController: _pressedWordsController,
              ),
            ],
          ),
        );
      },
    );
  }
}

@immutable
class HighResolutionPatch {
  const HighResolutionPatch({
    required this.image,
    required this.details,
  });
  final ui.Image image;
  final Rect details;
}
