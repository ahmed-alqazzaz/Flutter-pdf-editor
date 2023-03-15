import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/widgets/sliding_appbars/appbars/top/tab_icon.dart';

PreferredSizeWidget topAppbar(int pageNumber) => AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_sharp),
        onPressed: () {},
      ),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        TabIcon(tabNumber: pageNumber),
      ],
      title: const Text(
        'AppBar',
        style: TextStyle(color: Colors.black),
      ),
    );
