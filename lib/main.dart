import 'package:flutter/material.dart';

import 'package:pdf_editor/views/login/login_view.dart';

// import com.facebook.FacebookSdk;
// import com.facebook.appevents.AppEventsLogger;

void main() {
  runApp(const PDFEditor());
}

class PDFEditor extends StatefulWidget {
  const PDFEditor({super.key});

  @override
  State<PDFEditor> createState() => _PdfEditorState();
}

class _PdfEditorState extends State<PDFEditor> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginView(),
    );
  }
}
