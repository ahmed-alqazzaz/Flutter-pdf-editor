import 'package:flutter/cupertino.dart';
import 'package:pdf_editor/pdf_renderer/renderer.dart';

import '../../../pdf_renderer/data.dart';
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

  Future<List<CachedPage>> get pages async => await PdfRenderer.open(path).then(
        (converter) => converter.cache,
      );

  PdfFile updateName(String newName) {
    final newFilePath = (path.split('/')..last = '$newName.pdf').join('/');
    return copyWith(path: newFilePath);
  }

  String get name => path.split('/').last;
  PdfFile copyWith(
      {String? path,
      DateTime? uploadDate,
      bool? isCached,
      String? coverPagePath}) {
    return PdfFile(
      path: path ?? this.path,
      uploadDate: uploadDate ?? this.uploadDate,
      coverPagePath: coverPagePath != null ? coverPagePath : this.coverPagePath,
    );
  }

  @override
  String toString() =>
      'PdfFile(path: $path, coverPagePath: $coverPagePath, uploadDate: $uploadDate)';

  @override
  bool operator ==(covariant PdfFile other) {
    if (identical(this, other)) return true;

    return other.path == path &&
        other.coverPagePath == coverPagePath &&
        other.uploadDate == uploadDate;
  }

  @override
  int get hashCode =>
      path.hashCode ^ coverPagePath.hashCode ^ uploadDate.hashCode;
}
