import 'package:flutter/material.dart';

import '../../../../crud/pdf_db_manager/data/data.dart';
import '../../generics/pdf_file_list_tile.dart';

class FilesListView extends StatelessWidget {
  const FilesListView({
    super.key,
    required this.pdfFiles,
    required this.onFileTapped,
    this.onOptionsIconTapped,
  });
  static const double trailingIconSize = 30;
  static const double trailingIconSplashRadius = 25;

  final List<PdfFile> pdfFiles;
  final void Function(PdfFile) onFileTapped;
  final void Function(PdfFile)? onOptionsIconTapped;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final file = pdfFiles.reversed.toList()[index];
        return TextButton(
          onPressed: () => onFileTapped(file),
          child: PdfFileListTile(
            file: file,
            trailing: onOptionsIconTapped != null
                ? IconButton(
                    iconSize: trailingIconSize,
                    splashRadius: trailingIconSplashRadius,
                    onPressed: () => onOptionsIconTapped!(file),
                    icon: const Icon(
                      Icons.more_vert_outlined,
                      size: trailingIconSize,
                    ),
                  )
                : null,
          ),
        );
      },
      itemCount: pdfFiles.length,
    );
  }
}
