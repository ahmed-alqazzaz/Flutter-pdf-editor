import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pdf_editor/homepage/views/tools/generic_tool_view.dart';

import '../../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../generics/select_pages_view/select_pages_view.dart';

class SelectPagesView extends ToolView {
  const SelectPagesView({super.key, required this.file});

  final PdfFile file;
  static const String _title = 'Select pages';
  static const String _proceedButtonTitle = 'SELECT';

  @override
  Widget body() {
    return GenericSelectPagesView(
      file: file,
      title: _title,
      onProceed: (indexes) {},
      proceedButtonTitle: _proceedButtonTitle,
    );
  }
}
