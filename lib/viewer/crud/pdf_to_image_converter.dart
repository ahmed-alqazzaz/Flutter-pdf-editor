import 'dart:async';
import 'dart:io';

import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_editor/viewer/crud/text_recognizer.dart';

class PdfToImage {
  // create a singelton
  factory PdfToImage() => _shared;

  PdfToImage._sharedInstance();

  bool isDocumentOpen = false;

  static final PdfToImage _shared = PdfToImage._sharedInstance();

  late final Dimensions _pdfDimensions;
  PdfDocument? _pdfDocument;
  late final String? _pdfPath;

  Dimensions get pdfDimensions {
    if (isDocumentOpen == false) {
      throw UnimplementedError();
    }
    return _pdfDimensions;
  }

  Future<PdfDocument> get pdfDocument async => await _open();

  // cache is meant to store:
  // 1 - low resolution images when the viewer is initialized or page is disposed
  // 2 - high resolution images when pages are active
  final _cache = <int, PageImage>{};
  Map<int, PageImage> get cache => _cache;

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
    final document = await pdfDocument;
    for (int pageNumber = 1; pageNumber <= document.pagesCount; pageNumber++) {
      await getOrUpdateImage(
        pageNumber: pageNumber,
        scaleFactor: 1,
        useCache: false,
      );
    }
  }

  Future<PageImage> getOrUpdateImage({
    required final int pageNumber,
    required final double scaleFactor,
    final bool useCache = true,
  }) async {
    if (isDocumentOpen == false) {
      throw UnimplementedError();
    }

    final document = await pdfDocument;
    if (scaleFactor <= 0) {
      throw ArgumentError("scale must be a positive integer");
    }
    if (pageNumber > document.pagesCount || pageNumber <= 0) {
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
      final pdfFileName = _pdfPath!.split("/").last.split(".").first;
      final imageFolderPath = await _getImageDirectory(pdfFileName);
      final imagePath = '$imageFolderPath/image${pageNumber}_$scaleFactor.jpg';

      PageImage? pageImage = await loadImage(
        imagePath: imagePath,
        scaleFactor: scaleFactor,
      );

      // in case there is no image in images folder
      if (pageImage == null) {
        // create image with the specified resolution
        final page = await document.getPage(pageNumber);
        final image = await page
            .render(
              width: page.width * scaleFactor,
              height: page.height * scaleFactor,
              format: PdfPageImageFormat.jpeg,
              quality: 100,
            )
            .whenComplete(() async => await page.close());

        // save image to image folder
        final File file = File(imagePath);
        file.writeAsBytesSync(image!.bytes, flush: true);

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

  // returns PageImage if an already existing image
  // is found in the images folder
  Future<PageImage?> loadImage({
    required String imagePath,
    required double scaleFactor,
  }) async {
    // check if file open
    if (isDocumentOpen == false) {
      throw UnimplementedError();
    }
    // check if image exists
    if (await File(imagePath).exists() != true) {
      return null;
    }
    return PageImage(
      path: imagePath,
      initialDimensions: Dimensions(
        width: pdfDimensions.width,
        height: pdfDimensions.height,
      ),
      dimensions: Dimensions(
        width: 396 * scaleFactor,
        height: 612 * scaleFactor,
      ),
    );
  }

  Future<void> open(String pdfPath) async {
    // in case file is already open
    if (_pdfDocument?.isClosed == false) {
      throw UnimplementedError();
    } // in case file does'nt exist

    else if (!(await File(pdfPath).exists())) {
      throw UnimplementedError();
    }
    _pdfPath = pdfPath;

    await _open();
    isDocumentOpen = true;

    // assign pdfDimension
    await pdfDocument.then(
      (doc) => doc.getPage(1).then(
        (page) async {
          await page.close();
          _pdfDimensions = Dimensions(
            width: page.width,
            height: page.height,
          );
        },
      ),
    );
  }

  Future<void> close() async {
    if (isDocumentOpen == false) {
      throw UnimplementedError();
    }
    try {
      _pdfDocument!.close();
      isDocumentOpen = false;
      _pdfPath = null;
      _cache.clear();
    } catch (e) {
      throw UnimplementedError();
    }
  }

  Future<PdfDocument> _open() async {
    if (_pdfDocument?.isClosed == false) {
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
  Future<String> _getImageDirectory(final String pdfName) async {
    final tempDirectory = await getTemporaryDirectory();

    // get the images folder
    final Directory imagesFolder =
        Directory('${tempDirectory.path}/$pdfName/$imageFolderName/');

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
