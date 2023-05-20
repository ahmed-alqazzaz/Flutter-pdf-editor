import 'package:flutter/src/widgets/scroll_view.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/tools/generic_tool_view.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_files_views/select_files_view.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../generics/selectable/selectability_provider.dart';

class MergeFilesView extends ToolView {
  const MergeFilesView({
    super.key,
    required this.files,
    required this.onCache,
  });

  final List<PdfFile> files;
  final void Function(PdfFile) onCache;
  static const String _title = 'Select files';
  static const String _proceedButtonTitle = 'MERGE';

  @override
  Widget body() {
    return SelectFilesView(
      files: files,
      title: _title,
      proceedButtonTitle: _proceedButtonTitle,
      onPdfFileCached: onCache,
      onProceed: (indexes) {},
    );
  }
}
