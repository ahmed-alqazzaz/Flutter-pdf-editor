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
  static Future<PdfDbManager> open(final String dbFilePath) async {
    return PdfDbManager._(
      await openDatabase(
        dbFilePath,
        version: 1,
        onCreate: (db, version) => db.execute(createFilesTableCommand),
      ),
    );
  }

  Future<void> close() async {
    if (!_db.isOpen) throw const FilesDataBaseIsClosedException();
    await _db.close();
  }

  Future<void> updateFile(final PdfFile file, final int fileId) async {
    if (!_db.isOpen) throw const FilesDataBaseIsClosedException();
    log((await _db.query(filesTable)).toString());
    log(fileId.toString());
    log(file.coverPagePath.toString());
    await _db.update(
      filesTable,
      {
        fileCoverPagePathColumn: file.coverPagePath,
        filePathColumn: file.path,
        downloadDateColumn: file.uploadDate.toString(),
      },
      where: '$idColumn = ?',
      whereArgs: [fileId],
    );
  }

  Future<void> addFile(final PdfFile file) async {
    if (!_db.isOpen) throw const FilesDataBaseIsClosedException();
    try {
      await _db.insert(filesTable, {
        filePathColumn: file.path,
        downloadDateColumn: file.uploadDate.toString(),
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw const PdfFileAlreadyExistsException();
      }
    }
  }

  Future<void> deleteFiles(final String filePath) async {
    if (!_db.isOpen) throw const FilesDataBaseIsClosedException();

    await _db.delete(
      filesTable,
      where: '$filePathColumn = ?',
      whereArgs: [filePath],
    );
  }

  Future<int> retrieveid(PdfFile file) async {
    return await _db
        .query(
      filesTable,
      columns: [idColumn],
      where:
          '$filePathColumn = ? OR $fileCoverPagePathColumn = ? OR $downloadDateColumn = ?',
      whereArgs: [file.path, file.coverPagePath, file.uploadDate.toString()],
    )
        .then((result) {
      assert(result.length == 1, 'retrived ids must be less than 2');
      return result[0][idColumn] as int;
    });
  }

  Future<Iterable<PdfFile>> retrieveFiles() async {
    if (!_db.isOpen) throw const FilesDataBaseIsClosedException();
    return await _db.query(filesTable).then((result) {
      return result.map((row) {
        return PdfFile.fromRow(row);
      });
    });
  }
}
