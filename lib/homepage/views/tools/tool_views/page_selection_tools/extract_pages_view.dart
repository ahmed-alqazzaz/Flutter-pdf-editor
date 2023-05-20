import 'package:flutter/material.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../generic_tool_view.dart';
import '../../generics/select_pages_view/select_pages_view.dart';

class ExtractPagesView extends ToolView {
  const ExtractPagesView({super.key, required this.file});

  final PdfFile file;
  static const String _title = 'Extract pages';
  static const String _proceedButtonTitle = 'EXTRACT';

  @override
  Widget body() {
    return GenericSelectPagesView(
      file: file,
      title: _title,
      proceedButtonTitle: _proceedButtonTitle,
      onProceed: (indexes) {},
    );
  }
}
