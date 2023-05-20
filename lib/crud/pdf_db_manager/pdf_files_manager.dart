import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_editor/crud/pdf_db_manager/data/constants.dart';
import 'package:pdf_editor/crud/pdf_db_manager/data/data.dart';
import 'package:pdf_editor/crud/pdf_db_manager/pdf_db_manager.dart';

@immutable
class PdfFilesManager {
  final files = <PdfFile>[];

  final PdfDbManager _dbManager;
  PdfDbManager get manager => _dbManager;
  PdfFilesManager._(this._dbManager);
  static Future<PdfFilesManager> initialize() async {
    return getApplicationDocumentsDirectory().then(
      (documentDirectory) =>
          PdfDbManager.open(documentDirectory.path + dbName).then(
        (dbManager) async {
          final manager = PdfFilesManager._(dbManager);
          await manager._cache();
          return manager;
        },
      ),
    );
  }

  Future<void> updateFile(final PdfFile newFile) async {
    final id =
        files.indexOf(files.firstWhere((file) => file.path == newFile.path));
    files[id] = newFile;
    await _dbManager.updateFile(newFile, id + 1);
  }

  Future<void> addFile(final PdfFile file) async {
    files.add(file);
    return await _dbManager.addFile(file);
  }

  Future<void> deleteFiles(final List<int> filesId) async {
    for (final id in filesId) {
      files.removeAt(id);
      await _dbManager.deleteFiles(id + 1);
    }
  }

  Future<void> close() => _dbManager.close();
  Future<void> _cache() async {
    await _dbManager.retrieveFiles().then(
          (pdfFiles) => pdfFiles..forEach((pdfFile) => files.add(pdfFile)),
        );
  }
}
