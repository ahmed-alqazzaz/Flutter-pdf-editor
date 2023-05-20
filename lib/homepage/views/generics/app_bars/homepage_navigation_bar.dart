import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../helpers/custom_icons.dart/custom_icons.dart';

class HomePageNavigationBar extends StatelessWidget {
  const HomePageNavigationBar({
    super.key,
    required this.onItemTapped,
    required this.indexController,
  });

  static const _selectedIconColor = Colors.deepPurple;
  final StreamController<int> indexController;
  final Function(int) onItemTapped;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: indexController.stream,
        builder: (context, snapshot) {
          return BottomNavigationBar(
            currentIndex: snapshot.data ?? 0,
            selectedItemColor: _selectedIconColor,
            onTap: (index) {
              onItemTapped(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.file_copy_outlined),
                label: 'Files',
              ),
              BottomNavigationBarItem(
                icon: Icon(CustomIcons.compress),
                label: 'Tools',
              ),
            ],
          );
        });
  }
}
