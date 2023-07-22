import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/utils/request_directory.dart';
import 'package:pdf_editor/homepage/views/generics/selectable/selectability_provider.dart';
import 'package:pdf_editor/homepage/views/tools/generics/seperate_pages_view.dart';

import '../../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../../../crud/pdf_manipulator/pdf_manipulator.dart';

class InsertPagesView extends ConsumerWidget {
  const InsertPagesView({
    super.key,
    required this.file1,
    required this.file2,
    required this.selectedFile1Pages,
    required this.generatedFileName,
    required this.onProceed,
  });

  final PdfFile file1;
  final PdfFile file2;
  final List<int> selectedFile1Pages;
  final String generatedFileName;
  final Function(File) onProceed;
  static const _title = 'Select Insertion Point';

  void _insertPages({
    required int index,
    required int file1PageCount,
    required int file2PageCount,
  }) {
    requestDirectory().then(
      (directory) async {
        if (directory != null) {
          onProceed(
            await PDFManipulator().insert(
              file1PageCount: file1PageCount,
              file2PageCount: file2PageCount,
              filePath1: file1.path,
              filePath2: file2.path,
              selectedFile1Pages: selectedFile1Pages,
              insertionPoint: index,
              targetPath: '${directory.path}/$generatedFileName',
            ),
          );
        }
      },
    );
  }

  Widget _insertionPointBuilder({
    required Function() onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: FloatingActionButton(
        onPressed: onPressed,
        elevation: 3,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file1PageCount = ref.read(selectabilityProvider).indexCount!;
    return SeperatePagesView(
      file: file2,
      title: _title,
      seperator: (index) => _insertionPointBuilder(
        onPressed: () {
          for (var i = 0; i < 4; i++) {
            Navigator.of(context).pop();
          }

          _insertPages(
            index: index,
            file1PageCount: file1PageCount,
            file2PageCount: ref.read(selectabilityProvider).indexCount!,
          );
          ref.read(selectabilityProvider).clear();
        },
      ),
    );
  }
}
