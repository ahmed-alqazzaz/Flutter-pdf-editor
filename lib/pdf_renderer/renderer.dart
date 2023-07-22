import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:mutex/mutex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_editor/pdf_renderer/rust_pdf_renderer/rust_pdf_renderer.dart';

import 'data.dart';

final mutex = Mutex();

class PdfRenderer {
  PdfRenderer(this._cache);
  final List<CachedPage> _cache;
  List<CachedPage> get cache => List.unmodifiable(_cache);
  static Future<PdfRenderer> open(String pdfPath) async {
    try {
      await mutex.acquire();
      final rustRenderer = RustPdfRenderer.instance();
      final cacheDirectory = await _createCacheDirectory(pdfPath);
      if (!rustRenderer.isIntialized) await rustRenderer.initialize();

      await rustRenderer.loadPdf(pdfPath);
      log("caching at $cacheDirectory");
      final cachedPages = await rustRenderer.cacheAllPages(cacheDirectory);
      log("finnished caching within some time");
      final cache = <CachedPage>[
        for (var i = 0; i < cachedPages.length; i++) ...[
          CachedPage(
            pageNumber: cachedPages[i].$2 + 1,
            size: Size(
              cachedPages[i].$1.width.toDouble(),
              cachedPages[i].$1.height.toDouble(),
            ),
            path: "$cacheDirectory/image${i + 1}.png",
          )
        ]
      ];
      return PdfRenderer(cache);
    } finally {
      mutex.release();
    }
  }

  CachedPage get coverImage =>
      cache.firstWhere((element) => element.pageNumber == 1);

  Future<RustPageImage> renderImage({
    required int pageNumber,
    required double scaleFactor,
    Rect? pageCropRect,
  }) {
    return RustPdfRenderer.instance().renderPage(
      scaleFactor: scaleFactor,
      pageNumber: pageNumber,
      renderRect: pageCropRect,
    );
  }

  // this is used when file name is changed
  static Future<void> relocateCache({
    required String previousFileName,
    required String newFileName,
  }) async {
    final tempDir = await getTemporaryDirectory();
    final previousPath =
        "${tempDir.path}/${previousFileName.split('.pdf').first}";
    final newFilePath = "${tempDir.path}/${newFileName.split('.pdf').first}";
    await Directory(previousPath).rename(newFilePath);
  }

  static Future<String> _createCacheDirectory(String pdfPath) async {
    final tempDir = await getTemporaryDirectory();
    final pdfName = pdfPath.split("/").last.split(".pdf").first;
    final directoryPath = "${tempDir.path}/$pdfName";
    final directory = Directory(directoryPath);
    if (!directory.existsSync()) directory.createSync(recursive: true);
    return directory.path;
  }
}
