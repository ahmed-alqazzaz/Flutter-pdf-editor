import 'dart:async';

import 'dart:io';
import 'dart:math';
import 'dart:ui' as ui;
import 'dart:developer' as dev show log;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/viewer/crud/text_recognizer.dart';

import 'package:rxdart/rxdart.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../bloc/page_bloc.dart';
import '../bloc/page_events.dart';
import '../bloc/page_states.dart';
import '../crud/pdf_to_image_converter.dart';

class PdfPageProvider extends StatelessWidget {
  const PdfPageProvider({
    super.key,
    required this.pageNumber,
    required this.viewportController,
    required this.appBarsVisibilityController,
  });
  final int pageNumber;
  final BehaviorSubject<Matrix4> viewportController;
  final BehaviorSubject<bool> appBarsVisibilityController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PageBloc(),
      child: PageStack(
        pageNumber: pageNumber,
        viewportController: viewportController,
        appBarsVisibilityController: appBarsVisibilityController,
      ),
    );
  }
}

class PageStack extends StatefulWidget {
  const PageStack({
    super.key,
    required this.pageNumber,
    required this.viewportController,
    required this.appBarsVisibilityController,
  });
  final int pageNumber;
  final BehaviorSubject<Matrix4> viewportController;
  final BehaviorSubject<bool> appBarsVisibilityController;

  @override
  State<PageStack> createState() => _PageStackState();
}

class _PageStackState extends State<PageStack> {
  late final StreamSubscription<Matrix4> _viewportSubscription;
  late final BehaviorSubject<Word> _pressedWordsController;
  Timer? scaleFactorTimer;
  bool _isPageOnView = false;
  Rect? _pageVisibleBounds;

  @override
  void initState() {
    _pressedWordsController = BehaviorSubject<Word>();
    scaleFactorTimer = Timer(const Duration(milliseconds: 1500), () {
      _viewportSubscription =
          widget.viewportController.stream.listen((viewport) async {
        final state = context.read<PageBloc>().state;
        // update page resolution when viewport changes
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
          dev.log("page not on view");
        }
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    scaleFactorTimer?.cancel();
    _viewportSubscription.cancel();
    _pressedWordsController.close();
    PdfToImage().resetCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageDimension =
        PdfToImage().cache[widget.pageNumber]!.initialDimensions;

    return BlocBuilder<PageBloc, PageState>(
      builder: (context, state) {
        return RawGestureDetector(
          gestures: {
            DoubleTapGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                DoubleTapGestureRecognizer>(
              () => DoubleTapGestureRecognizer(),
              (DoubleTapGestureRecognizer instance) {
                instance.onDoubleTap = () {
                  // hide/show app bar when there is a double click
                  final areAppbarsVisible =
                      widget.appBarsVisibilityController.valueOrNull;

                  widget.appBarsVisibilityController.sink.add(
                    areAppbarsVisible != null ? !areAppbarsVisible : false,
                  );
                };
              },
            ),
            PdfPageGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<PdfPageGestureRecognizer>(
              () => PdfPageGestureRecognizer(),
              (PdfPageGestureRecognizer instance) {
                instance.onTapDown = (localPosition) async {
                  if (state is PageStateUpdatingDisplay &&
                      state.extractedText != null) {
                    for (final line in state.extractedText!.lines) {
                      for (final word in line.words) {
                        if (word.isGestureWithinRange(
                            localPosition, state.extractedText!.scaleFactor)) {
                          _pressedWordsController.sink.add(word);

                          print(word.text);
                        } else {}
                      }
                    }
                  }
                };
              },
            )
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
                    if (details.visibleBounds.right != 0 &&
                        details.visibleBounds.bottom != 0) {
                      _pageVisibleBounds = details.visibleBounds;
                      if (widget.viewportController.hasValue) {
                        ////   dev.log("on view");
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
                            pow(
                                widget.viewportController.value
                                    .getMaxScaleOnAxis(),
                                2) *
                            (details.size.width > size.width
                                ? pageToScreenRatio
                                : 1);

                        // TODO: check for appbar
                        // REMINDER: i added 0.1 because the app bar was taking 10% of the window
                        dev.log(
                            "${pageVisibleFraction.toString()} ${widget.pageNumber}");
                        if (pageVisibleFraction + 0.1 > 0.7) {
                          _isPageOnView = true;
                        } else {
                          _isPageOnView = false;
                        }
                      }
                    }
                  },
                  child: state is PageStateUpdatingDisplay // use cached image
                      ? Stack(
                          children: [
                            RawImage(
                              image: state.mainImage,
                              fit: BoxFit.fill,
                              width: 396,
                              height: 612,
                              key: UniqueKey(),
                            ),
                            if (state.highResolutionPatch != null) ...[
                              Positioned(
                                width:
                                    state.highResolutionPatch!.details.width /
                                        state.scaleFactor,
                                height:
                                    state.highResolutionPatch!.details.height /
                                        state.scaleFactor,
                                left: state.highResolutionPatch!.details.left /
                                    state.scaleFactor,
                                top: state.highResolutionPatch!.details.top /
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
                      : Image.file(
                          File(PdfToImage().cache[widget.pageNumber]!.path),
                          fit: BoxFit.fill,
                          width: 396,
                          height: 612,
                          key: UniqueKey(),
                        ),
                ),
              ),
              StreamBuilder(
                stream: _pressedWordsController.stream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    state as PageStateUpdatingDisplay;
                    final word = snapshot.data!;

                    return Positioned(
                      top: word.position.top,
                      //bottom: 81,
                      left: word.position.left,
                      child: Opacity(
                        opacity: 0.5,
                        child: SizedBox(
                          height: word.dimensions.height,
                          width: word.dimensions.width,
                          child: const DecoratedBox(
                            decoration:
                                BoxDecoration(color: Colors.lightGreenAccent),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              )
              // if (state is PageStateDisplaying &&
              //     state.extractedText != null) ...[
              //   for (final line in state.extractedText!.lines)
              //     for (final word in line.words)
              // Positioned(
              //     top: word.position.top / state.extractedText!.scaleFactor,
              //     bottom: 81,
              //     left:
              //         word.position.left / state.extractedText!.scaleFactor,
              //     child: Opacity(
              //       opacity: 0.5,
              //       child: GestureDetector(
              //         onTap: () {
              //           print(word.text);
              //         },
              //         child: SizedBox(
              //           height: word.dimensions.height /
              //               state.extractedText!.scaleFactor,
              //           width: word.dimensions.width /
              //               state.extractedText!.scaleFactor,
              //           child: const DecoratedBox(
              //             decoration: BoxDecoration(color: Colors.red),
              //           ),
              //         ),
              //       ),
              //     )
              //     right: MediaQuery.of(context).size.width - 63.4,
              //     ),
              // ],
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

class PdfPageGestureRecognizer extends OneSequenceGestureRecognizer {
  Function(Offset)? onTapDown;

  PdfPageGestureRecognizer();

  Offset? _tapDownPosition;
  bool _isTapDown = false;

  @override
  void addPointer(PointerDownEvent event) {
    super.addPointer(event);

    _tapDownPosition = event.position;
    _isTapDown = true;
  }

  // call tap down only when distance between tap down and up is less than kToupSlop
  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      final distance = (_tapDownPosition! - event.position).distance;
      if (distance > kTouchSlop) {
        _isTapDown = false;
      }
    } else if (event is PointerUpEvent) {
      if (_isTapDown) {
        onTapDown?.call(event.localPosition);
      }
      _isTapDown = false;
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void dispose() {
    super.dispose();
    _isTapDown = false;
  }

  @override
  String get debugDescription => throw UnimplementedError();
}
