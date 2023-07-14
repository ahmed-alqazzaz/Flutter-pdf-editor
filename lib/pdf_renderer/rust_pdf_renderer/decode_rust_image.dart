import 'dart:async';
import 'dart:ui' as ui;
import 'package:pdf_editor/pdf_renderer/rust_bridge/ffi.dart';

extension ImageDecoder on PageImage {
  Future<ui.Image> decodeImage() async {
    final Completer<ui.Image> completer = Completer();
    final pixels = data.buffer.asUint8List();
    ui.decodeImageFromPixels(
      pixels,
      pixelWidthCount,
      pixelHeightCount,
      ui.PixelFormat.rgba8888,
      (ui.Image img) {
        completer.complete(img);
      },
    );
    return await completer.future;
  }
}
