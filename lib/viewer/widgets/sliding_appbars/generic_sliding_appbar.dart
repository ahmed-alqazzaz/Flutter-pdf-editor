import 'package:flutter/material.dart';

class GenericSlidingAppBar extends StatelessWidget {
  const GenericSlidingAppBar({
    super.key,
    required this.child,
    required this.controller,
    required this.slidingOffset,
  });

  final Widget child;
  final AnimationController controller;
  final Offset slidingOffset;

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
