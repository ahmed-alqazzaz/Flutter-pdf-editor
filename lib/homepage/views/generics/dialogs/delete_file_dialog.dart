import 'package:flutter/material.dart';
import 'package:pdf_editor/homepage/views/generics/dialogs/generic_dialog.dart';

const String _title = "Confirm?";
const String _content =
    "This file will be deleted. This actions can not be undone";
const String _proceedButtonText = 'YES';
const String _dismissButtonText = 'NO';

Future<T?> showDeleteFileDialog<T>(
    {required BuildContext context, required void Function() onProceed}) async {
  return showGenericAlertDialog<T>(
    context: context,
    title: const Text(_title),
    content: const Text(_content),
    proceedButtonText: _proceedButtonText,
    dismissButtonText: _dismissButtonText,
    onProceed: onProceed,
  );
}
