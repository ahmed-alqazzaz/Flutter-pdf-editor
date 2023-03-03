import 'dart:async';

import 'package:flutter/material.dart';

import 'loading_screen_controller.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? _controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller != null) {
      _controller!.update(text);
    } else {
      _controller = _showOverlay(
        context: context,
        text: text,
      );
    }
  }

  void hide() {
    _controller?.close();
    _controller = null;
  }

  LoadingScreenController _showOverlay({
    required BuildContext context,
    required String text,
  }) {
    // ignore: no_leading_underscores_for_local_identifiers
    final _text = StreamController<String>();

    _text.sink.add("Signing in... ");

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlayEntry = OverlayEntry(
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent.withOpacity(0.5),
          child: IgnorePointer(
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: size.height * 0.1,
                          minWidth: size.width * 0.85,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // white space width is 10% of its parent
                            SizedBox(width: size.width * 0.8 * 0.1),
                            const CircularProgressIndicator(),
                            SizedBox(width: size.width * 0.8 * 0.1),
                            StreamBuilder(
                              stream: _text.stream,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return Text(snapshot.data as String,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          color: Colors.black54));
                                } else {
                                  return const CircularProgressIndicator();
                                }
                              },
                            ),
                            const SizedBox(width: 15),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlayEntry);
    return LoadingScreenController(
      close: () {
        overlayEntry.remove();
        _text.close();
      },
      update: (String text) {
        _text.add(text);
      },
    );
  }
}
