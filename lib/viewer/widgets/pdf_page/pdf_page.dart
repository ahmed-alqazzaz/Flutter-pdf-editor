import 'dart:async';

import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:developer' as dev show log;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf_editor/viewer/crud/pdf_to_image_converter/data.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page_gesture_detector/pdf_page_gesture_detector.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/word_highlight.dart';

import 'package:rxdart/rxdart.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'bloc/page_bloc.dart';
import 'bloc/page_events.dart';
import 'bloc/page_states.dart';
import '../../crud/pdf_to_image_converter/pdf_to_image_converter.dart';

class PdfPage extends StatefulWidget {
  const PdfPage({
    super.key,
    required this.scaffoldKey,
    required this.pageNumber,
    required this.viewportController,
    required this.appBarsVisibilityController,
    required this.scrollController,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int pageNumber;
  final BehaviorSubject<Matrix4> viewportController;
  final BehaviorSubject<bool> appBarsVisibilityController;
  final ScrollController scrollController;

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
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
    if (details.visibleBounds.right != 0 &&
        details.visibleBounds.bottom != 0 &&
        details.visibleBounds != _pageVisibleBounds) {
      // viewportController updates its value 300 milliseconds
      // after visibilityChange is triggered so timer is necessary
      // to prevent using old viewport

      visibilityChangeTimer?.cancel();
      visibilityChangeTimer = Timer(
        const Duration(milliseconds: 50),
        () {
          // print(details.visibleBounds.top);
          _pageVisibleBounds = details.visibleBounds;
          if (widget.viewportController.hasValue) {
            final scaleFactor =
                widget.viewportController.value.getMaxScaleOnAxis();

            // in case viewport controller and visibility detector are'nt synchronized
            if (details.size.width ~/ scaleFactor != width.toInt()) {
              return onPageVisibilityChanges(context, details, width);
            }
            //dev.log("hhh ${(details.size.width / scaleFactor).toString()}");
            // general page visibility fraction (same irregardless of zoom)
            // is the page visibility fraction when zoom level (scale level) is 1
            // multiplied by the zoom level squared
            // and in case page width is larger than the render object (zoom > 1):
            // it's multiplied by pdf page to screen page size ratio
            final pageDimension = PdfToImage().cache[widget.pageNumber]!.size;
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
            // dev.log("${pageVisibleFraction.toString()} ${widget.pageNumber}");

            if (pageVisibleFraction + 0.1 > 0.1) {
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
    scaleFactorTimer = Timer(const Duration(milliseconds: 800), () {
      // when the timer runs less than 0.8 seconds after
      // initstate executes, the subscription won't be able
      // to listen to viewport changes prior to its creation causing
      // the state to be stuck; thus, adding the last viewport, if available,
      // is necessary to trigger the listener
      if (widget.viewportController.hasValue) {
        // timer is necessary to ensure that this runs
        // after the viewportSubscription is created
        Timer(const Duration(milliseconds: 40), () {
          widget.viewportController.add(widget.viewportController.value);
        });
      }

      _viewportSubscription =
          widget.viewportController.stream.listen((viewport) async {
        final state = context.read<PageBloc>().state;
        if (_isPageOnView) {
          // dev.log(viewport.getMaxScaleOnAxis().toString());
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
    visibilityChangeTimer?.cancel();
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

    return BlocBuilder<PageBloc, PageState>(
      builder: (context, state) {
        return ProviderScope(
          overrides: [
            wordInteractionProvider.overrideWith(
              (ref) => WordInteractionModel(),
            )
          ],
          child: PdfPageGestureDetector(
            scaleFactor:
                state is PageStateUpdatingDisplay ? state.scaleFactor : 1,
            scrollController: widget.scrollController,
            appBarsVisibilityController: widget.appBarsVisibilityController,
            extractedText:
                state is PageStateUpdatingDisplay ? state.extractedText : null,
            pdfPageWidth: pdfPageSize.width,
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
                        onPageVisibilityChanges(context, info, screenWidth),
                    child: state is PageStateUpdatingDisplay
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
                            File(PdfToImage().cache[widget.pageNumber]!.path),
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
          ),
        );
      },
    );
  }
}

class WordInteractionModel extends ChangeNotifier {
  Rect? _wordBoundingBox;
  PersistentBottomSheetController? _bottomSheetController;

  Rect? get wordBoundingBox => _wordBoundingBox;
  bool get isThereTappedWord => _wordBoundingBox != null;

  void updateTappedWord({
    required final Rect wordBoundingBox,
    PersistentBottomSheetController? bottomSheetController,
  }) {
    _wordBoundingBox = wordBoundingBox;
    _bottomSheetController = bottomSheetController;
    notifyListeners();
  }

  void reset() {
    _bottomSheetController?.close();
    _wordBoundingBox = null;
    _bottomSheetController = null;
    notifyListeners();
  }
}

final wordInteractionProvider = ChangeNotifierProvider<WordInteractionModel>(
  (ref) => WordInteractionModel(),
);
