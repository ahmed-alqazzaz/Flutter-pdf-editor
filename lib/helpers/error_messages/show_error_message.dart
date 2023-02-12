import 'package:flutter/cupertino.dart';

import 'error_message.dart';

void showErrorMessage({
  required BuildContext context,
  required String text,
}) async {
  final overlayEntry = OverlayEntry(
    builder: (context) {
      return ErrorMessage(text: text);
    },
  );
  Overlay.of(context)!.insert(overlayEntry);

  await Future.delayed(const Duration(seconds: 3)).then((value) {
    overlayEntry.remove();
  });
}
