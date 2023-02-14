import 'package:flutter/cupertino.dart';

import 'error_message.dart';

void showErrorMessage({
  required BuildContext context,
  required String text,
  required Duration duration,
}) async {
  final overlayEntry = OverlayEntry(
    builder: (context) {
      return ErrorMessage(
        text: text,
        duration: Duration(milliseconds: duration.inMilliseconds - 700),
      );
    },
  );
  Overlay.of(context)!.insert(overlayEntry);
  print(duration.inMilliseconds);
  await Future.delayed(duration).then((value) {
    overlayEntry.remove();
  });
}
