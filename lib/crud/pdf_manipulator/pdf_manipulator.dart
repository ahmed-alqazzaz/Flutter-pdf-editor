import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_manipulator/pdf_manipulator.dart';

@immutable
class PDFManipulator {
  PDFManipulator() : _manipulator = PdfManipulator();
  final PdfManipulator _manipulator;
  Future<File> discardPages({
    required String filePath,
    required String targetPath,
    required List<int> pageNumbers,
  }) async {
    return (await relocateFile(
      originalPath: (await _manipulator.pdfPageDeleter(
        params:
            PDFPageDeleterParams(pdfPath: filePath, pageNumbers: pageNumbers),
      ))!,
      targetPath: targetPath,
    ));
  }

  Future<File> extractPages({
    required String filePath,
    required int pageCount,
    required String targetPath,
    required List<int> pageNumbers,
  }) async {
    log('selected pages file 1 $pageNumbers');
    final pageIndices = Iterable.generate(pageCount, (i) => i + 1).toList();
    final discardedIndices = pageIndices
      ..removeWhere((index) => pageNumbers.contains(index));
    return discardPages(
      filePath: filePath,
      targetPath: targetPath,
      pageNumbers: discardedIndices,
    );
  }

  Future<File> insert({
    required String filePath1,
    required String filePath2,
    required int file1PageCount,
    required int file2PageCount,
    required int insertionPoint,
    required List<int> selectedFile1Pages,
    required String targetPath,
  }) async {
    final cacheDirectory = await getTemporaryDirectory();
    final splitFile = await split(
        filePath: filePath2,
        pageCount: file2PageCount,
        splittingPoint: insertionPoint,
        targetPaths: [
          "${cacheDirectory.path}/1.pdf",
          "${cacheDirectory.path}/2.pdf"
        ]).toList();
    final insertedFile = await extractPages(
      filePath: filePath1,
      pageCount: file1PageCount,
      targetPath: "${cacheDirectory.path}/3.pdf",
      pageNumbers: selectedFile1Pages,
    );

    return await mergeFiles(
      filePaths: [splitFile[0].path, insertedFile.path, splitFile[1].path],
      targetPath: targetPath,
    );
  }

  Future<File> compressFile({
    required String filePath,
    required String targetPath,
  }) async {
    return (await relocateFile(
      originalPath: (await _manipulator.pdfCompressor(
        params: PDFCompressorParams(
            pdfPath: filePath, imageQuality: 1, imageScale: 0.1),
      ))!,
      targetPath: targetPath,
    ));
  }

  Future<File> mergeFiles({
    required List<String> filePaths,
    required String targetPath,
  }) async {
    return await relocateFile(
      originalPath: (await _manipulator.mergePDFs(
          params: PDFMergerParams(pdfsPaths: filePaths)))!,
      targetPath: targetPath,
    );
  }

  Stream<File> split({
    required String filePath,
    required int pageCount,
    required int splittingPoint,
    required List<String> targetPaths,
  }) async* {
    assert(splittingPoint < pageCount,
        'the number of target paths must match the page ranges');
    final pageIndices = List.generate(pageCount, (i) => i + 1);
    final pageRanges = [
      pageIndices.sublist(0, splittingPoint + 1),
      pageIndices.sublist(splittingPoint + 1, pageCount)
    ].reversed.toList();
    for (int i = 0; i < targetPaths.length; i++) {
      yield await discardPages(
        filePath: filePath,
        targetPath: targetPaths[i],
        pageNumbers: pageRanges[i],
      );
    }
  }

  Future<File> relocateFile({
    required String originalPath,
    required String targetPath,
  }) {
    final originalFile = File(originalPath);
    assert(originalFile.existsSync(), "non-existent files can't be relocated");
    final targetFile = File(targetPath);
    return targetFile.writeAsBytes(originalFile.readAsBytesSync()).whenComplete(
          () async => await originalFile.delete(),
        );
  }
}
