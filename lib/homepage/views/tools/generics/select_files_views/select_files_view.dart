import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pdf_editor/homepage/views/generics/pdf_file_list_tile.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selection_view/selection_view.dart';
import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../generics/selectable/selectability_provider.dart';

class SelectFilesView extends SelectionView {
  const SelectFilesView({
    super.key,
    required this.files,
    required super.title,
    required super.proceedButtonTitle,
    required this.onPdfFileCached,
    required super.onProceed,
  });

  final List<PdfFile> files;
  final Function(PdfFile) onPdfFileCached;

  @override
  Widget body(WidgetRef ref) {
    ref.read(selectabilityProvider).setIndexCount(files.length);
    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (BuildContext context, int index) {
        final file = files[index];
        return PdfFileListTile(
          file: file,
          onFileCached: onPdfFileCached,
          trailing: Consumer(
            builder: (context, ref, child) {
              final isSelected = ref.watch(selectabilityProvider.select(
                (selectabilityModel) =>
                    selectabilityModel.selectedIndexes.contains(index),
              ));
              return Checkbox(
                value: isSelected,
                onChanged: (value) {
                  ref.read(selectabilityProvider).onTap(index);
                },
              );
            },
          ),
        );
      },
    );
  }
}
