import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddFilesButton extends StatelessWidget {
  const AddFilesButton({
    super.key,
    required this.onFilesPicked,
  });
  final void Function(FilePickerResult) onFilesPicked;
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf'],
          allowMultiple: true,
          allowCompression: false,
          withData: true,
          withReadStream: true,
        );
        if (result != null) {
          onFilesPicked(result);
        }
      },
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add),
    );
  }
}
