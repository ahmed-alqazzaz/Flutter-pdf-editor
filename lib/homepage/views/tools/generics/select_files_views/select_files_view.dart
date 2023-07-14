import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:pdf_editor/homepage/views/generics/pdf_file_list_tile.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selection_view/selection_view.dart';
import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../generics/selectable/selectability_provider.dart';

class SelectFilesView extends SelectionView {
  SelectFilesView({
    super.key,
    required this.files,
    required Function(List<int>) onProceed,
  }) : super(
            title: 'Select',
            proceedButtonTitle: 'Select File',
            onProceed: (List<int> selectedFiles, WidgetRef ref) {
              ref.read(selectabilityProvider).clear();
              onProceed(selectedFiles);
            });

  final List<PdfFile> files;

  @override
  Widget body(WidgetRef ref) {
    ref.read(selectabilityProvider).setIndexCount(files.length + 1);
    return WillPopScope(
      onWillPop: () async {
        ref.read(selectabilityProvider).clear();
        return true;
      },
      child: Consumer(builder: (context, ref, _) {
        ref.watch(selectabilityProvider);
        return ListView.builder(
          itemCount: files.length,
          itemBuilder: (BuildContext context, int index) {
            final file = files[index];
            return PdfFileListTile(
              file: file,
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
      }),
    );
  }
}
