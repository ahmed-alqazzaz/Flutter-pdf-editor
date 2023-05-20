import 'package:flutter/cupertino.dart';
import 'package:pdf_editor/crud/pdf_db_manager/pdf_files_manager.dart';
import 'package:pdf_editor/crud/pdf_to_image_converter/data.dart';

import '../../pdf_to_image_converter/pdf_to_image_converter.dart';
import 'constants.dart';

@immutable
class PdfFile {
  const PdfFile({
    required this.path,
    required this.uploadDate,
    required this.coverPagePath,
  });
  final String path;
  final String? coverPagePath;
  final DateTime uploadDate;

  PdfFile.fromRow(Map<String, Object?> row)
      : path = row[filePathColumn] as String,
        coverPagePath = row[fileCoverPagePathColumn] as String?,
        uploadDate = DateTime.parse(row[downloadDateColumn] as String);

  Future<Map<int, PageImage>> get pages async =>
      await PdfToImage.open(path).then(
        (converter) => converter.cache,
      );

  String get name => path.split('/').last;
  PdfFile copyWith(
      {String? path,
      DateTime? uploadDate,
      bool? isCached,
      String? coverPagePath}) {
    return PdfFile(
        path: path ?? this.path,
        uploadDate: uploadDate ?? this.uploadDate,
        coverPagePath: coverPagePath ?? this.coverPagePath);
  }
}
