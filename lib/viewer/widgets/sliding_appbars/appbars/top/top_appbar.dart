import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/widgets/sliding_appbars/appbars/top/tab_icon.dart';

import '../../appbar_popup_menu_button.dart/appbar_popup_menu_button.dart';

PreferredSizeWidget topAppbar(int pageNumber) => AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_sharp),
        onPressed: () {},
      ),
      backgroundColor: Colors.white,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        const IconButton(
          onPressed: null,
          icon: Icon(
            Icons.find_in_page_outlined,
            color: Colors.black,
            size: 28,
          ),
        ),
        TabIcon(tabNumber: pageNumber),
        const AppbarPopupMenuButton(),
      ],
      title: const Text(
        'AppBar',
        style: TextStyle(color: Colors.black),
      ),
    );
