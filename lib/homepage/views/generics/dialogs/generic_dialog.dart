import 'package:flutter/material.dart';
import 'package:pdf_editor/generics/generic_button.dart';

Future<T?> showGenericAlertDialog<T>({
  required BuildContext context,
  required Widget title,
  required Widget content,
  required String proceedButtonText,
  required String dismissButtonText,
  required void Function() onProceed,
}) async {
  final size = MediaQuery.of(context).size;
  return await showDialog<T>(
    context: context,
    barrierColor: Colors.black26,
    builder: (context) {
      return AlertDialog(
        elevation: 1,
        title: title,
        content: SizedBox(
          width: size.width,
          child: content,
        ),
        actions: [
          GenericButton.large(
            color: Colors.white,
            textColor: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
            size: Size(
              size.width * 0.20,
              size.height * 0.045,
            ),
            child: Text(dismissButtonText),
          ),
          GenericButton.large(
            color: Colors.deepPurple,
            textColor: Colors.white,
            onPressed: () {
              onProceed();
              Navigator.of(context).pop();
            },
            size: Size(
              size.width * 0.20,
              size.height * 0.045,
            ),
            child: Text(proceedButtonText),
          ),
        ],
      );
    },
  );
}
