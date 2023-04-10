import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';

class SlidingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SlidingAppBar({
    super.key,
    required this.child,
    required this.controller,
    required this.visibility,
    required this.slidingOffset,
  });

  final PreferredSizeWidget child;
  final AnimationController controller;
  final bool visibility;
  final Offset slidingOffset;

  @override
  Size get preferredSize => child.preferredSize;

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(begin: Offset.zero, end: slidingOffset).animate(
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn),
      ),
      child: child,
    );
  }
}
