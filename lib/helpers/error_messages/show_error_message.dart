import 'package:flutter/cupertino.dart';

import 'error_message.dart';

void showErrorMessage({
  required BuildContext context,
  required String text,
  required Duration duration,
}) async {
  final overlayEntry = OverlayEntry(
    builder: (context) {
      /*
      the error message actual duration will be 700 milliseconds less than 
      the requested duration due to the time spent in the fade in/out animation
      */
      return ErrorMessage(
        text: text,
        duration: Duration(milliseconds: duration.inMilliseconds - 700),
      );
    },
  );
  Overlay.of(context).insert(overlayEntry);
  await Future.delayed(duration).then((value) => overlayEntry.remove());
}
