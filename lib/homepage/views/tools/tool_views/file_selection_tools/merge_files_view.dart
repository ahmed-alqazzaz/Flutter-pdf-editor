import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/generics/selectable/selectability_provider.dart';
import 'package:pdf_editor/homepage/views/tools/generic_tool_view.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../utils/request_directory.dart';
import '../../generics/select_files_views/order_files_view.dart';

class MergeFilesView extends ToolView {
  MergeFilesView({
    super.key,
    required this.files,
    required this.generatedFileName,
    required this.onProceed,
  });

  final List<PdfFile> files;
  final Function(File) onProceed;
  static const String _title = 'Select files';
  static const String _proceedButtonTitle = 'MERGE';
  final String generatedFileName;
  void merge({
    required BuildContext context,
    required WidgetRef ref,
    required List<String> filePaths,
  }) {
    requestDirectory().then((directory) {
      if (directory != null) {
        pdfManipulator
            .mergeFiles(
                filePaths: filePaths,
                targetPath: '${directory.path}/$generatedFileName')
            .then(
          (file) {
            onProceed(file);
            onExit(context, ref);
            Navigator.of(context).pop();
          },
        );
      }
    });
  }

  @override
  Widget body(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () async {
        ref.read(selectabilityProvider).clear();
        return true;
      },
      child: ReorderableFilesView(
        files: files,
        title: _title,
        proceedButtonTitle: _proceedButtonTitle,
        onProceed: (indexes, ref) {
          merge(
            context: context,
            ref: ref,
            filePaths: [for (final index in indexes) files[index].path],
          );
        },
      ),
    );
  }
}
