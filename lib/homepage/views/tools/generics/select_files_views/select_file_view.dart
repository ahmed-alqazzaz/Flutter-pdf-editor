import 'package:flutter/material.dart';
import 'package:pdf_editor/homepage/views/files_view/widgets/files_list_view.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../generics/app_bars/generic_app_bar.dart';

class SelectFileView extends StatelessWidget {
  const SelectFileView({
    super.key,
    required this.files,
    required this.onFileTapped,
    String? title,
  }) : title = title ?? 'Select File';

  final String title;
  final List<PdfFile> files;
  final Function(BuildContext, PdfFile) onFileTapped;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: GenericHomePageAppBar.titleTextColor),
        ),
      ),
      body: FilesListView(
        pdfFiles: files,
        onFileTapped: (file) => onFileTapped(context, file),
      ),
    );
  }
}
