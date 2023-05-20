import 'package:flutter/material.dart';

@immutable
abstract class PdfFilesDataBaseException implements Exception {
  const PdfFilesDataBaseException();
}

class PdfFileAlreadyExistsException extends PdfFilesDataBaseException {
  const PdfFileAlreadyExistsException();
}

class FilesDataBaseIsClosedException extends PdfFilesDataBaseException {
  const FilesDataBaseIsClosedException();
}
