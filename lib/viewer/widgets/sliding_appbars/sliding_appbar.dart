import 'dart:ui';

import 'package:flutter/material.dart';
import 'appbars/bottom/bottom_appbar.dart';
import 'appbars/top/top_appbar.dart';

class SlidingAppBars extends StatelessWidget {
  const SlidingAppBars({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const TopAppBar(tabNumber: 1),
        Flexible(
          flex: 10,
          child: Container(),
        ),
        BottomAppbar(),
      ],
    );
  }
}
