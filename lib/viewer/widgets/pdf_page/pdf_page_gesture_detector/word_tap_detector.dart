import 'package:flutter/gestures.dart';

class WordTapGestureRecognizer extends OneSequenceGestureRecognizer {
  Function(PointerUpEvent)? onTapUp;

  WordTapGestureRecognizer();

  Offset? _tapDownPosition;
  bool _isTapDown = false;

  @override
  void addPointer(PointerDownEvent event) {
    super.addPointer(event);

    _tapDownPosition = event.position;
    _isTapDown = true;
  }

  // call tap down only when distance between tap down and up is less than kToupSlop
  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerMoveEvent) {
      final distance = (_tapDownPosition! - event.position).distance;
      if (distance > kTouchSlop) {
        _isTapDown = false;
      }
    } else if (event is PointerUpEvent) {
      if (_isTapDown) {
        onTapUp?.call(event);
      }
      _isTapDown = false;
    }
  }

  @override
  void didStopTrackingLastPointer(int pointer) {}

  @override
  void dispose() {
    super.dispose();
    _isTapDown = false;
  }

  @override
  String get debugDescription => "PdfPageWordPressCRecognizer";
}