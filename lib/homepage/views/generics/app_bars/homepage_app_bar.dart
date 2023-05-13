import 'dart:async';

import 'package:flutter/material.dart';

import '../../files_view/widgets/app_bar/app_bar.dart';
import 'generic_app_bar.dart';

class HomePageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function(String) onSearchQueryUpdate;

  final StreamController<int> indexController;

  const HomePageAppBar(
      {super.key,
      required this.onSearchQueryUpdate,
      required this.indexController});
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: indexController.stream,
      builder: (context, snapshot) {
        if (snapshot.data == 1) {
          return const GenericHomePageAppBar(
            title: Text(
              'Tools',
              style: TextStyle(
                color: GenericHomePageAppBar.titleTextColor,
              ),
            ),
            leading: Icon(Icons.menu),
          );
        }
        return FilesAppBar(onQueryUpdated: onSearchQueryUpdate);
      },
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
