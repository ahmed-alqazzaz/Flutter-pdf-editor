// import 'dart:io';
// import 'package:pdf_render/pdf_render.dart';

// class PdfDocumentManager {
//   PdfDocumentManager._(this.document, this.fileName);
//   final PdfDocument document;
//   final String fileName;

//   static Future<PdfDocumentManager> open(final String pdfPath) async {
//     if (!(await File(pdfPath).exists())) {
//       throw UnimplementedError();
//     }
//     final pdfName = pdfPath.split("/").last.split(".").first;
//     return PdfDocumentManager._(
//       await PdfDocument.openFile(pdfPath),
//       pdfName,
//     );
//   }

//   Future<void> close() async => await document.dispose();
// }
