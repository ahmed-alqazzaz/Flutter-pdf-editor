import 'package:flutter/material.dart';
import 'package:pdf_editor/homepage/views/generics/dialogs/generic_dialog.dart';

const String _title = "Sign out?";
const String _content = "Are you sure you want to log out?";
const String _proceedButtonText = 'Sign out';
const String _dismissButtonText = 'Cencel';
Future<T?> showSignOutDialog<T>(
    {required BuildContext context, required void Function() onProceed}) {
  return showGenericAlertDialog<T>(
    context: context,
    title: const Text(_title),
    content: const Text(_content),
    proceedButtonText: _proceedButtonText,
    dismissButtonText: _dismissButtonText,
    onProceed: onProceed,
  );
}
