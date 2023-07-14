import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/tools/generic_tool_view.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../utils/request_directory.dart';
import '../../generics/select_pages_view/select_pages_view.dart';

class DiscardPagesView extends ToolView {
  DiscardPagesView({
    super.key,
    required this.file,
    required this.onProceed,
    required this.generatedFileName,
  });

  final PdfFile file;
  final String generatedFileName;
  final Function(File) onProceed;
  static const String _title = 'Discard pages';
  static const String _proceedButtonTitle = 'DISCARD';

  void discardPages(
      {required BuildContext context,
      required WidgetRef ref,
      required List<int> discardedPages}) {
    requestDirectory().then((directory) async {
      onExit(context, ref);
      if (directory != null) {
        onProceed(
          await pdfManipulator.discardPages(
            filePath: file.path,
            targetPath: '${directory.path}/$generatedFileName',
            pageNumbers: discardedPages,
          ),
        );
      }
    });
  }

  @override
  Widget body(BuildContext context, WidgetRef ref) {
    return GenericSelectPagesView(
      file: file,
      title: _title,
      proceedButtonTitle: _proceedButtonTitle,
      onProceed: (indexes, ref) {
        discardPages(context: context, ref: ref, discardedPages: indexes);
      },
    );
  }
}
