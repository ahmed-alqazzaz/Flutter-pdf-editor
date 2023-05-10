import 'dart:developer';

import 'package:flutter/cupertino.dart';

import '../../pdf_to_image_converter/pdf_to_image_converter.dart';
import 'constants.dart';

@immutable
class PdfFile {
  const PdfFile({
    required this.path,
    required this.uploadDate,
    this.isCached = true,
  });
  final String path;
  final DateTime uploadDate;
  final bool isCached;

  PdfFile.fromRow(Map<String, Object?> row)
      : path = row[filePathColumn] as String,
        uploadDate = DateTime.parse(row[downloadDateColumn] as String),
        isCached = true;

  Future<String> get coverPagePath async {
    return await PdfToImage.open(path, cache: !isCached).then(
      (converter) => converter.coverImage.then(
        (pageImage) => pageImage.path,
      ),
    );
  }

  String get name => path.split('/').last;
  PdfFile copyWith({
    String? path,
    DateTime? uploadDate,
    bool? isCached,
  }) {
    return PdfFile(
      path: path ?? this.path,
      uploadDate: uploadDate ?? this.uploadDate,
      isCached: isCached ?? this.isCached,
    );
  }
}
