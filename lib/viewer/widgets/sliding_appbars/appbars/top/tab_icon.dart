import 'package:flutter/material.dart';

class TabIcon extends StatelessWidget {
  final int tabNumber;
  const TabIcon({super.key, required this.tabNumber});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: null,
      icon: Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Colors.black,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: Text(
            tabNumber.toString(),
            style: const TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
