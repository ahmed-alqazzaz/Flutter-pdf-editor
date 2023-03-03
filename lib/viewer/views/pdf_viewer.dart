import 'dart:async';
import 'dart:io';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

import '../crud/pdf_to_image_converter.dart';
import '../widgets/pdf_page.dart';

class PdfViewer extends StatefulWidget {
  const PdfViewer({super.key});

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late final BehaviorSubject<double> _currentScaleLevel;
  late final TransformationController _transformationController;
  late final ScrollController _scrollController;
  @override
  void initState() {
    _currentScaleLevel = BehaviorSubject<double>();
    _transformationController = TransformationController();
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _currentScaleLevel.close();
    _transformationController.dispose();
    _scrollController.dispose();
    PdfToImage().close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: initializePdfViewer(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final screenWidth = MediaQuery.of(context).size.width;
            final pdfPageWidth = PdfToImage().pdfDimensions.width;
            return InteractiveViewer(
              transformationController: _transformationController,
              onInteractionUpdate: (details) {
                _currentScaleLevel.sink
                    .add(_transformationController.value.getMaxScaleOnAxis());
              },
              maxScale: 10,
              minScale: 0.1,
              child: DraggableScrollbar.semicircle(
                controller: _scrollController,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(
                      horizontal: (screenWidth - pdfPageWidth) / 2),
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
            );
          } else {
            return const CircularProgressIndicator(
              color: Colors.red,
            );
          }
        },
      ),
    );
  }
}

Future<void> initializePdfViewer() async {
  final dir = await getApplicationDocumentsDirectory();

  // Create a file path to the document directory
  String filePath = '${dir.path}/test.pdf';

  // Open the asset file
  ByteData data = await rootBundle.load('assets/pdf-test.pdf');

  // Write the asset file to the document directory
  File file = File(filePath);
  await file.writeAsBytes(data.buffer.asUint8List(), flush: true);

  await PdfToImage().open("${dir.path}/test.pdf");
  await PdfToImage().cacheAll();
}
