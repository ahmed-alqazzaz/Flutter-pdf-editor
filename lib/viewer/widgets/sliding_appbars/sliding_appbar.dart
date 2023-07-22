import 'package:flutter/material.dart';
import 'appbars/bottom/bottom_appbar.dart';
import 'appbars/top/top_appbar.dart';

class SlidingAppBars extends StatelessWidget {
  const SlidingAppBars({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopAppBar(tabNumber: 1, title: title),
        Flexible(
          flex: 10,
          child: Container(),
        ),
        BottomAppbar(),
      ],
    );
  }
}
