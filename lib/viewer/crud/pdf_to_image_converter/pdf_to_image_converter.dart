import 'dart:async';
import 'dart:developer';

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render.dart';
import 'package:path_provider/path_provider.dart';

import 'data.dart';

class PdfToImage {
  PdfToImage._(this._documentManager);

  // cache is meant to store:
  // low resolution images(scale factor =< 3 ) when the viewer is initialized
  final _cache = <int, PageImage>{};
  Map<int, PageImage> get cache => _cache;

  final PdfDocumentManager _documentManager;

  static Future<PdfToImage> initialize(String pdfPath) async {
    final converter = PdfToImage._(await PdfDocumentManager.open(pdfPath))
      ..path = pdfPath;
    await converter._cacheAll();
    return converter;
  }

  PdfDocument get _document => _documentManager.document;

  String? path;

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
  Future<void> _cacheAll() async {
    final x = Stopwatch()..start();
    for (int pageNumber = 1; pageNumber <= _document.pageCount; pageNumber++) {
      await getOrUpdateImage(
        pageNumber: pageNumber,
        scaleFactor: 1,
        useCache: false,
      );
    }
    log("cached in ${x.elapsedMilliseconds}");
  }

  // this is intended to return full image with scale factor < 3
  Future<PageImage> getOrUpdateImage({
    required final int pageNumber,
    required final double scaleFactor,
    final bool useCache = true,
  }) async {
    if (scaleFactor <= 0) {
      throw ArgumentError("scale must be a positive integer");
    }

    if (pageNumber > _document.pageCount || pageNumber <= 0) {
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

        final page = await _document.getPage(pageNumber);
        pageImage = PageImage(
          path: file.path,
          scaleFactor: scaleFactor,
          size: Size(page.width, page.height),
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
    return _document.getPage(pageNumber).then((page) async {
      // pdfToScreenRatio MUST only be used when pageCropRect != null
      late final pdfToScreenWidthRatio = page.width / pageCropRect!.width;
      return await page.render(
        height: pageCropRect != null
            ? (pageCropRect.height * pdfToScreenWidthRatio).toInt()
            : (page.height * scaleFactor).toInt(),
        width: pageCropRect != null
            ? page.width.toInt()
            : (page.width * scaleFactor).toInt(),
        fullHeight: page.height * scaleFactor,
        fullWidth: page.width * scaleFactor,
        x: pageCropRect != null
            ? (pageCropRect.left * pdfToScreenWidthRatio).toInt()
            : 0,
        y: pageCropRect != null
            ? (pageCropRect.top * pdfToScreenWidthRatio).toInt()
            : 0,
      );
    }).then(
      (pdfPageImage) async =>
          pdfPageImage.imageIfAvailable ??
          await pdfPageImage.createImageIfNotAvailable(),
    );
  }

  // returns PageImage if an already existing image
  // is found in the images folder
  Future<PageImage?> loadImage({required String imagePath}) async {
    // check if image exists
    if (await File(imagePath).exists() != true) {
      return null;
    }

    // extract scale factor and page number from the path
    final pageNumber =
        int.parse(imagePath.split("/").reversed.toList()[0].split('').first);
    final scaleFactor = double.parse(imagePath.split("/").reversed.toList()[1]);

    final page = await _document.getPage(pageNumber);
    return PageImage(
      path: imagePath,
      scaleFactor: scaleFactor,
      size: Size(page.width, page.height),
    );
  }

  Future<void> close() async => _documentManager.close();

  Future<String> _createImagePath({
    required int pageNumber,
    required double scaleFactor,
  }) async {
    final imageFolderPath = await _getImageDirectory(
      _documentManager.fileName,
      scaleFactor,
    );
    return '$imageFolderPath/$pageNumber.jpg';
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

const imageFolderName = "images";

class PdfDocumentManager {
  PdfDocumentManager._(this.document, this.fileName);
  final PdfDocument document;
  final String fileName;

  static Future<PdfDocumentManager> open(final String pdfPath) async {
    if (!(await File(pdfPath).exists())) {
      throw UnimplementedError();
    }
    final pdfName = pdfPath.split("/").last.split(".").first;
    return PdfDocumentManager._(
      await PdfDocument.openFile(pdfPath),
      pdfName,
    );
  }

  Future<void> close() async => await document.dispose();
}
