import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/tools/generic_tool_view.dart';

import '../../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../generics/selectable/selectability_provider.dart';
import '../../../generics/select_pages_view/select_pages_view.dart';

class SelectPagesView extends ToolView {
  SelectPagesView({super.key, required this.file, required this.onProceed});

  final PdfFile file;
  final void Function(List<int> selectedPages) onProceed;
  static const String _title = 'Select pages';
  static const String _proceedButtonTitle = 'SELECT';

  @override
  Widget body(BuildContext context, WidgetRef ref) {
    return GenericSelectPagesView(
      file: file,
      title: _title,
      onProceed: (indexes, ref) {
        ref.read(selectabilityProvider).clear();

        onProceed(indexes);
      },
      proceedButtonTitle: _proceedButtonTitle,
    );
  }
}
