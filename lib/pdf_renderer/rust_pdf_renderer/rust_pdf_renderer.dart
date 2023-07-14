import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../rust_bridge/ffi.dart';

typedef RustPageImage = PageImage;
const pdfiumAssetPath = "assets/libpdfium.so";

class RustPdfRenderer {
  factory RustPdfRenderer.instance() => _instance;
  static final _instance = RustPdfRenderer._internal();
  RustPdfRenderer._internal();

  bool isIntialized = false;
  Future<void> initialize() async {
    assert(!isIntialized, "library is already initialized");
    final libData = await rootBundle.load(pdfiumAssetPath);
    final libBytes = libData.buffer.asUint8List();

    // Save the library to the document directory
    final directory = await getApplicationDocumentsDirectory();
    final libPath = '${directory.path}/libpdfium.so';
    final libFile = File(libPath);
    if (!libFile.existsSync()) await libFile.writeAsBytes(libBytes);
    await api.initializeLibrary(libPath: libPath);
    isIntialized = true;
  }

  Future<void> loadPdf(String path) async {
    assert(isIntialized, "library has not been initialized");
    assert(
      File(path).existsSync(),
      "Unable to loacate pdf file with path: $path",
    );
    await api.loadPdfFile(filepath: path);
  }

  Future<List<(Size, int)>> cacheAllPages(String cachePath) async {
    assert(isIntialized, "library has not been initialized");
    return await api.cacheCurrentFile(cacheDir: cachePath);
  }

  Future<RustPageImage> renderPage({
    required double scaleFactor,
    required int pageNumber,
    required Rect? renderRect,
  }) async {
    assert(isIntialized, "library has not been initialized");
    try {
      return await api.renderPage(
        pageNumber: pageNumber,
        scaleFactor: scaleFactor,
        renderRect: renderRect != null
            ? RenderRect(
                top: renderRect.top,
                left: renderRect.left,
                width: renderRect.width,
                height: renderRect.height,
              )
            : null,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<Size> getPageSize(int pageNumber) async {
    final rustSize = await api.pageSize(pageNumber: pageNumber);
    return Size(width: rustSize.width, height: rustSize.height);
  }
}
