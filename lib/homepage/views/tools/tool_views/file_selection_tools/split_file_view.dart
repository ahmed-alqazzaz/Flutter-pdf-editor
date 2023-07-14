import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:pdf_editor/homepage/views/tools/generic_tool_view.dart';
import 'package:pdf_editor/homepage/views/tools/generics/seperate_pages_view.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../utils/request_directory.dart';
import '../../../generics/selectable/selectability_provider.dart';

class SplitFileView extends ToolView {
  SplitFileView({
    super.key,
    required this.file,
    required this.generatedFileNames,
    required this.onProceed,
  });

  final List<String> generatedFileNames;
  final PdfFile file;
  final Function(Stream<File> files) onProceed;
  static const _title = "Select Splitting Point";

  void split({
    required int splittingPoint,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    final pageCount = ref.read(selectabilityProvider).indexCount!;
    onExit(context, ref);
    requestDirectory().then((directory) async {
      if (directory != null) {
        try {
          final targetPaths = [
            for (final name in generatedFileNames) '${directory.path}/$name'
          ];
          final files = pdfManipulator.split(
            filePath: file.path,
            targetPaths: targetPaths,
            pageCount: pageCount,
            splittingPoint: splittingPoint,
          );
          onProceed(files);
        } catch (e) {
          log(e.toString());
        }
      }
      return null;
    });
  }

  Widget _splittingPointBuilder({
    required int splittingPoint,
    required BuildContext context,
    required WidgetRef ref,
  }) {
    return RawMaterialButton(
      onPressed: () =>
          split(splittingPoint: splittingPoint, context: context, ref: ref),
      child: const Column(
        children: [
          Icon(Icons.keyboard_arrow_up),
          Icon(Icons.keyboard_arrow_down)
        ],
      ),
    );
  }

  @override
  Widget body(BuildContext context, WidgetRef ref) {
    return SeperatePagesView(
      file: file,
      title: _title,
      seperator: (index) => _splittingPointBuilder(
        context: context,
        ref: ref,
        splittingPoint: index,
      ),
    );
  }
}
