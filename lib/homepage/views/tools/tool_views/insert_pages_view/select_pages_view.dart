import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pdf_editor/homepage/views/tools/tool_view.dart';

class SelectPagesView extends ToolView {
  const SelectPagesView({super.key, required super.file});

  static const String _title = 'Select pages';
  static const String _proceedButtonTitle = 'SELECT';
  @override
  Widget build(BuildContext context) {
    return super.toolView(
      title: _title,
      proceedButtonTitle: _proceedButtonTitle,
      onProceed: (selectedIndexes) {},
    );
  }
}
