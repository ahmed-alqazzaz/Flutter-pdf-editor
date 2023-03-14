import 'dart:async';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:rxdart/rxdart.dart';

import '../crud/pdf_to_image_converter.dart';
import '../widgets/pdf_page.dart';
import '../widgets/sliding_appbars.dart';
import 'dart:ui' as ui;
import 'dart:developer' as dev;

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> with WidgetsBindingObserver {
  late final BehaviorSubject<bool> _appBarsVisibilityController;
  late final BehaviorSubject<Matrix4> _viewportController;
  late final TransformationController _transformationController;
  late final ScrollController _scrollController;

  Timer? _vieweportUpdatingTimer;

  void _updateViewPort() {
    _vieweportUpdatingTimer?.cancel();
    _vieweportUpdatingTimer = Timer(
      const Duration(milliseconds: 300),
      () => _viewportController.sink.add(
        _transformationController.value,
      ),
    );
  }

  @override
  void initState() {
    _appBarsVisibilityController = BehaviorSubject<bool>();
    _viewportController = BehaviorSubject<Matrix4>();
    _transformationController = TransformationController();
    _scrollController = ScrollController();

    // add first value to viewportController
    _viewportController.sink.add(
      _transformationController.value,
    );

    super.initState();
  }

  @override
  void dispose() {
    _appBarsVisibilityController.close();
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
        body: NotificationListener<ScrollEndNotification>(
          onNotification: (notification) {
            _updateViewPort();
            return true;
          },
          child: InteractiveViewer(
            transformationController: _transformationController,
            onInteractionEnd: (details) {
              _updateViewPort();
            },
            maxScale: 10,
            minScale: 0.1,
            child: DraggableScrollbar.semicircle(
              controller: _scrollController,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                  horizontal: (screenWidth - 396) / 2,
                ),
                itemCount: 10, //PdfToImage().cache.length,
                itemBuilder: (context, index) {
                  return PdfPageProvider(
                    key: Key(index.toString()),
                    viewportController: _viewportController,
                    pageNumber: index + 1,
                    appBarsVisibilityController: _appBarsVisibilityController,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
