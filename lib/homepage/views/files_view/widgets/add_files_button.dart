import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../crud/pdf_db_manager/pdf_files_manager.dart';
import '../../../bloc/home_bloc.dart';
import '../../../bloc/home_events.dart';

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
        // final manager = await PdfFilesManager.initialize();
        if (result != null) {
          onFilesPicked(result);
        }

        //manager.manager.db.delete('files');
      },
      backgroundColor: Colors.deepPurple,
      child: const Icon(Icons.add),
    );
  }
}
