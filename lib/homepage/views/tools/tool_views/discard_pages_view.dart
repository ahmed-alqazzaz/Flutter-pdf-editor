import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_editor/homepage/views/tools/tool_view.dart';
import 'package:permission_handler/permission_handler.dart';

class DiscardPagesView extends ToolView {
  const DiscardPagesView({super.key, required super.file});

  static const String _title = 'Discard pages';
  static const String _proceedButtonTitle = 'DISCARD';
  @override
  Widget build(BuildContext context) {
    return super.toolView(
      title: _title,
      proceedButtonTitle: _proceedButtonTitle,
      onProceed: (selectedIndexes) async {
        await Permission.storage.request();

        final destinationDirectory =
            await FilePicker.platform.getDirectoryPath();

        if (destinationDirectory != null) {
          // Check if the destination directory exists
          if (Directory(destinationDirectory).existsSync()) {
            // Create the directory if it doesn't exist
            final dir = Directory(destinationDirectory)
              ..createSync(recursive: true);
            final destinationLocation = '${dir.path}/hhh.pdf';
            final filee = File(destinationLocation);
            if (!filee.existsSync()) {
              filee.writeAsBytesSync(File(file.path).readAsBytesSync());
            } else {
              throw UnimplementedError();
            }
            print('executed');
          }
        }
      },
    );
  }
}
