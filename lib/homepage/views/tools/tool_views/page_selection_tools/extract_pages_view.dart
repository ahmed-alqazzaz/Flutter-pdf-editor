import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../utils/request_directory.dart';
import '../../../generics/selectable/selectability_provider.dart';
import '../../generic_tool_view.dart';
import '../../generics/select_pages_view/select_pages_view.dart';

class ExtractPagesView extends ToolView {
  ExtractPagesView({
    super.key,
    required this.file,
    required this.generatedFileName,
    required this.onProceed,
  });

  final PdfFile file;
  final String generatedFileName;
  final void Function(File) onProceed;
  static const String _title = 'Extract pages';
  static const String _proceedButtonTitle = 'EXTRACT';

  void extractPages({
    required BuildContext context,
    required List<int> extractedPages,
    required WidgetRef ref,
  }) {
    requestDirectory().then((directory) async {
      onExit(context, ref);
      final pageCount = ref.read(selectabilityProvider).indexCount!;
      if (directory != null) {
        onProceed(
          await pdfManipulator.extractPages(
            filePath: file.path,
            pageCount: pageCount,
            targetPath: '${directory.path}/$generatedFileName',
            pageNumbers: extractedPages,
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
      onProceed: (indices, ref) {
        extractPages(
          context: context,
          ref: ref,
          extractedPages: indices,
        );
      },
    );
  }
}
