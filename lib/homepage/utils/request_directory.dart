import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<Directory?> requestDirectory() async {
  await Permission.storage.request();
  final destinationDirectory = await FilePicker.platform.getDirectoryPath();
  if (destinationDirectory != null) {
    final directory = Directory(destinationDirectory);
    return directory.existsSync()
        ? (directory..createSync(recursive: true))
        : null;
  }
  return null;
}
