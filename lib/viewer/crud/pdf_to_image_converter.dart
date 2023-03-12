import 'dart:async';

import 'dart:io';
import 'dart:ui' as ui;

import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_editor/viewer/crud/text_recognizer.dart';
import 'package:tuple/tuple.dart';

class PdfToImage {
  // create a singelton
  factory PdfToImage() => _shared;
  PdfToImage._sharedInstance();
  static final PdfToImage _shared = PdfToImage._sharedInstance();

  // cache is meant to store:
  // low resolution images(scale factor =< 3 ) when the viewer is initialized
  final _cache = <int, PageImage>{};
  Map<int, PageImage> get cache => _cache;

  PdfDocument? _pdfDocument;
  String? _pdfPath;

  Future<PdfDocument> get pdfDocument async => await _open();

  // this is meant to be executed after the page is disposed
  void resetCache() {
    // check if one of the cached scale factor is higher than 1
    cache.forEach((pageNumber, pageImage) async {
      if (pageImage.scaleFactor != 1) {
        // Update the image scale factor to 1
        await getOrUpdateImage(
          pageNumber: pageNumber,
          scaleFactor: 1,
          useCache: false,
        );
      }
    });
  }

  // this is meant to be used during the viewer initialazation
  Future<void> cacheAll() async {
    final x = Stopwatch()..start();
    final document = await pdfDocument;
    for (int pageNumber = 1; pageNumber <= document.pageCount; pageNumber++) {
      await getOrUpdateImage(
        pageNumber: pageNumber,
        scaleFactor: 1,
        useCache: false,
      );
    }
    print("cached in ${x.elapsedMilliseconds}");
  }

  // this is intended to return full image with scale factor < 3
  Future<PageImage> getOrUpdateImage({
    required final int pageNumber,
    required final double scaleFactor,
    final bool useCache = true,
  }) async {
    if (_pdfDocument == null) {
      throw UnimplementedError();
    }
    if (scaleFactor <= 0) {
      throw ArgumentError("scale must be a positive integer");
    }
    final document = await pdfDocument;
    if (pageNumber > document.pageCount || pageNumber <= 0) {
      throw UnimplementedError();
    }

    // return a cahced image if use_cache is set to true
    // and if the cached image has a same or  a higher resolution
    final cachedImage = _cache[pageNumber];
    if (cachedImage != null &&
        cachedImage.scaleFactor >= scaleFactor &&
        useCache) {
      return cachedImage;
    } else {
      final imagePath = await _createImagePath(
        pageNumber: pageNumber,
        scaleFactor: scaleFactor,
      );

      PageImage? pageImage = await loadImage(
        imagePath: imagePath,
      );

      // in case there is no image in images folder
      if (pageImage == null) {
        // create image with the specified resolution
        final image = await createImage(
          pageNumber: pageNumber,
          scaleFactor: scaleFactor,
        ).then((image) => image
            .toByteData(format: ui.ImageByteFormat.png)
            .then((byteData) => byteData!.buffer.asUint8List()));

        // save image to folder
        final file = File(imagePath);
        file.writeAsBytesSync(image);

        final page = await document.getPage(pageNumber);
        pageImage = PageImage(
          path: file.path,
          dimensions: Dimensions(
            width: page.width * scaleFactor,
            height: page.height * scaleFactor,
          ),
          initialDimensions: Dimensions(
            width: page.width,
            height: page.height,
          ),
        );
      }

      // Update cached images
      _cache[pageNumber] = pageImage;
      return pageImage;
    }
  }

  Future<ui.Image> createImage({
    required int pageNumber,
    required double scaleFactor,
    Rect? pageCropRect,
  }) async {
    return await pdfDocument.then((document) async => document
        .getPage(pageNumber)
        .then((page) async => await page.render(
              height: pageCropRect != null
                  ? pageCropRect.height.toInt()
                  : (page.height * scaleFactor).toInt(),
              width: pageCropRect != null
                  ? pageCropRect.width.toInt()
                  : (page.width * scaleFactor).toInt(),
              fullHeight: page.height * scaleFactor,
              fullWidth: page.width * scaleFactor,
              x: pageCropRect?.left.toInt() ?? 0,
              y: pageCropRect?.top.toInt() ?? 0,
            ))
        .then((pdfPageImage) async =>
            pdfPageImage.imageIfAvailable ??
            await pdfPageImage.createImageIfNotAvailable()));
  }

  // returns PageImage if an already existing image
  // is found in the images folder
  Future<PageImage?> loadImage({required String imagePath}) async {
    if (_pdfDocument != false) {
      throw UnimplementedError();
    }
    // check if image exists
    if (await File(imagePath).exists() != true) {
      return null;
    }

    // extract scale factor and page number from the path
    final pageNumber =
        int.parse(imagePath.split("/").reversed.toList()[0].split('').first);
    final scaleFactor = double.parse(imagePath.split("/").reversed.toList()[1]);

    final page = await pdfDocument.then(
      (document) async => await document.getPage(pageNumber),
    );
    return PageImage(
      path: imagePath,
      initialDimensions: Dimensions(
        width: page.width,
        height: page.height,
      ),
      dimensions: Dimensions(
        width: page.width * scaleFactor,
        height: page.height * scaleFactor,
      ),
    );
  }

  Future<void> open(String pdfPath) async {
    // in case file is already open
    if (_pdfDocument != null) {
      throw UnimplementedError();
    }
    // in case file does'nt exist
    else if (!(await File(pdfPath).exists())) {
      throw UnimplementedError();
    }
    _pdfPath = pdfPath;
    await _open();
  }

  Future<void> close() async {
    if (_pdfDocument == null) {
      throw UnimplementedError();
    }

    // TODO: remove redundant vars
    _pdfDocument = null;
    _pdfPath = null;
    _cache.clear();
  }

  Future<String> _createImagePath({
    required int pageNumber,
    required double scaleFactor,
  }) async {
    final pdfFileName = _pdfPath!.split("/").last.split(".").first;
    final imageFolderPath = await _getImageDirectory(pdfFileName, scaleFactor);
    return '$imageFolderPath/$pageNumber.jpg';
  }

  Future<PdfDocument> _open() async {
    if (_pdfDocument != null) {
      return _pdfDocument!;
    }
    if (_pdfPath == null) {
      throw UnimplementedError();
    }
    try {
      // Update _PdfDocument Value
      _pdfDocument = await PdfDocument.openFile(_pdfPath!);
      return _pdfDocument!;
    } catch (e) {
      throw UnimplementedError(e.toString());
    }
  }

  // return path to temporary folder that contain images
  Future<String> _getImageDirectory(String pdfName, double scaleFactor) async {
    final tempDirectory = await getTemporaryDirectory();

    // get the images folder
    final Directory imagesFolder = Directory(
        '${tempDirectory.path}/$pdfName/$imageFolderName/$scaleFactor');

    return await imagesFolder.exists().then(
      (value) async {
        // in case folder exists
        if (value) {
          return imagesFolder.path;
        }
        return await imagesFolder
            .create(recursive: true)
            .then((folder) => folder.path);
      },
    );
  }
}

class PageImage {
  PageImage({
    required this.path,
    required this.initialDimensions,
    required this.dimensions,
  });

  final Dimensions dimensions;
  final Dimensions initialDimensions;
  final String path;

  double get scaleFactor => dimensions.height / initialDimensions.height;
}

const imageFolderName = "images";
