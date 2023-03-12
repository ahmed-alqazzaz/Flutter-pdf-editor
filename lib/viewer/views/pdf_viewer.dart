import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:rxdart/rxdart.dart';

import '../crud/pdf_to_image_converter.dart';
import '../widgets/pdf_page.dart';
import '../widgets/sliding_appbars.dart';
import 'dart:ui' as ui;

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> with WidgetsBindingObserver {
  late final BehaviorSubject<bool> _showAppBarController;
  late final BehaviorSubject<Matrix4> _viewportController;
  late final TransformationController _transformationController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _showAppBarController = BehaviorSubject<bool>();
    _viewportController = BehaviorSubject<Matrix4>();
    _transformationController = TransformationController();
    _scrollController = ScrollController();

    _viewportController.sink.add(
      _transformationController.value,
    );
    super.initState();
  }

  @override
  void dispose() {
    _showAppBarController.close();
    _viewportController.close();
    _transformationController.dispose();
    _scrollController.dispose();
    PdfToImage().close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: InteractiveViewer(
          transformationController: _transformationController,
          onInteractionEnd: (details) {
            _viewportController.sink.add(
              _transformationController.value,
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
                      horizontal: (screenWidth - 396) / 2,
                    ),
                    itemCount: 1, //PdfToImage().cache.length,
                    itemBuilder: (context, index) {
                      return PdfPageProvider(
                        key: Key(index.toString()),
                        viewportController: _viewportController,
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
