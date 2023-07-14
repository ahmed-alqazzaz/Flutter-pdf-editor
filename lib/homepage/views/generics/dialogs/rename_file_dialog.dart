import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf_editor/homepage/views/generics/dialogs/generic_dialog.dart';

import '../generic_text_field.dart';

const _title = "Rename file";
const _proceedButtonText = "Rename";
const _dismissButtonText = "cancel";

Future<T?> showRenameFileDialog<T>({
  required BuildContext context,
  required String fileName,
  required void Function(String newName) onFileNamedChanged,
}) async {
  final controller = TextEditingController(text: fileName.split('.pdf')[0]);
  return showGenericAlertDialog<T>(
    context: context,
    title: _titleBuilder(fileName: fileName),
    content: GenericHomePageTextField(
      controller: controller,
      mainColor: Colors.deepPurple,
      contentPadding: const EdgeInsets.symmetric(vertical: 10),
    ),
    proceedButtonText: _proceedButtonText,
    dismissButtonText: _dismissButtonText,
    onProceed: () {
      final name = controller.text;
      if (name.isNotEmpty) {
        onFileNamedChanged(controller.text);
      }
    },
  ).whenComplete(
    () => Timer.periodic(
        const Duration(seconds: 1), (timer) => controller..clear()),
  );
}

Widget _titleBuilder({required String fileName}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      const Text(_title),
      const SizedBox(height: 10),
      Text(
        fileName,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
      ),
    ],
  );
}
