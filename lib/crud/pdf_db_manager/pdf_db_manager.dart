import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:pdf_editor/crud/pdf_db_manager/data/constants.dart';
import 'package:pdf_editor/crud/pdf_db_manager/data/data.dart';
import 'package:pdf_editor/crud/pdf_db_manager/data/exceptions.dart';
import 'package:sqflite/sqflite.dart';

@immutable
class PdfDbManager {
  const PdfDbManager._(this._db);
  final Database _db;
  Database get db => _db;
  static Future<PdfDbManager> open(final String dbFilePath) async =>
      PdfDbManager._(
        await openDatabase(
          dbFilePath,
          version: 1,
          onCreate: (db, version) => db.execute(createFilesTableCommand),
        ),
      );
  Future<void> close() async => await _db.close();

  Future<void> addFile(final PdfFile file) async {
    try {
      await _db.insert(filesTable, {
        filePathColumn: file.path,
        downloadDateColumn: file.uploadDate.toString(),
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw PdfFileAlreadyExistsException();
      }
    }
  }

  Future<void> deleteFiles(final int fileId) async {
    await _db.delete(
      filesTable,
      where: '$idColumn = ?',
      whereArgs: [fileId],
    );
  }

  Future<Iterable<PdfFile>> retrieveFiles() async =>
      await _db.query(filesTable).then((result) => result.map((row) {
            return PdfFile.fromRow(row);
          }));
}
