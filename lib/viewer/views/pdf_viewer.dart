import 'dart:async';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:rxdart/rxdart.dart';

import '../crud/pdf_to_image_converter.dart';
import '../widgets/pdf_page.dart';
import '../widgets/sliding_appbars.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> with WidgetsBindingObserver {
  late final BehaviorSubject<bool> _showAppBarController;
  late final BehaviorSubject<double> _currentScaleLevel;
  late final TransformationController _transformationController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _showAppBarController = BehaviorSubject<bool>();
    _currentScaleLevel = BehaviorSubject<double>();
    _transformationController = TransformationController();
    _scrollController = ScrollController();

    super.initState();
  }

  @override
  void dispose() {
    _showAppBarController.close();
    _currentScaleLevel.close();
    _transformationController.dispose();
    _scrollController.dispose();
    PdfToImage().close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build executed");
    final screenWidth = MediaQuery.of(context).size.width;
    final pdfPageWidth = PdfToImage().pdfDimensions.width;
    return SafeArea(
      child: Scaffold(
        body: InteractiveViewer(
          transformationController: _transformationController,
          onInteractionUpdate: (details) {
            _currentScaleLevel.sink.add(
              _transformationController.value.getMaxScaleOnAxis(),
            );
          },
          maxScale: 10,
          minScale: 0.1,
          child: Stack(
            children: [
              Listener(
                onPointerUp: (event) async {
                  // check if the tap is not a result of a scroll
                  if (_scrollController.position.userScrollDirection !=
                          ScrollDirection.forward &&
                      _scrollController.position.userScrollDirection !=
                          ScrollDirection.reverse) {
                    final isAppbarVisible = _showAppBarController.valueOrNull;
                    _showAppBarController.sink.add(
                      isAppbarVisible != null ? !isAppbarVisible : false,
                    );
                  }
                  // show/hide app bar when screen is clicked
                },
                child: DraggableScrollbar.semicircle(
                  controller: _scrollController,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(
                      horizontal: (screenWidth - pdfPageWidth) / 2,
                    ),
                    itemCount: PdfToImage().cache.length,
                    itemBuilder: (context, index) {
                      return PdfPage(
                        key: Key(index.toString()),
                        scaleLevel: _currentScaleLevel,
                        pageNumber: index + 1,
                      );
                    },
                  ),
                ),
              ),
              SlidingAppBars(
                showAppbarController: _showAppBarController,
              )
            ],
          ),
        ),
      ),
    );
  }
}





// Future<void> initializePdfViewer() async {
//   final dir = await getApplicationDocumentsDirectory();

//   await PdfToImage().open("${dir.path}/test.pdf");
//   await PdfToImage().cacheAll();
// }
