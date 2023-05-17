import 'package:flutter/material.dart';
import 'package:pdf_editor/homepage/views/tools/tool_view.dart';

class ExtractPagesView extends ToolView {
  const ExtractPagesView({super.key, required super.file});

  static const String _title = 'Extract pages';
  static const String _proceedButtonTitle = 'EXTRACT';
  @override
  Widget build(BuildContext context) {
    return super.toolView(
      title: _title,
      proceedButtonTitle: _proceedButtonTitle,
      onProceed: (selectedIndexes) {
        print(selectedIndexes);
      },
    );
  }
}
