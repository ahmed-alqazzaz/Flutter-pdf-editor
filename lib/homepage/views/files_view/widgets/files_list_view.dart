import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../crud/pdf_db_manager/data/data.dart';
import '../../generics/pdf_file_list_tile.dart';

class FilesListView extends StatelessWidget {
  const FilesListView({
    super.key,
    required this.pdfFiles,
    required this.onOptionsIconTapped,
    required this.onFileCached,
    required this.onFileTapped,
  });
  static const double trailingIconSize = 30;
  static const double trailingIconSplashRadius = 25;

  final List<PdfFile> pdfFiles;
  final void Function(PdfFile) onFileTapped;
  final void Function(PdfFile) onOptionsIconTapped;
  final void Function(PdfFile) onFileCached;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final file = pdfFiles[index];
        return TextButton(
          onPressed: () => onFileTapped(file),
          child: PdfFileListTile(
            file: file,
            onFileCached: onFileCached,
            trailing: IconButton(
              iconSize: trailingIconSize,
              splashRadius: trailingIconSplashRadius,
              onPressed: () => onOptionsIconTapped(file),
              icon: const Icon(
                Icons.more_vert_outlined,
                size: trailingIconSize,
              ),
            ),
          ),
        );
      },
      itemCount: pdfFiles.length,
    );
  }
}
