import 'package:flutter/material.dart';

import 'generic_sliding_appbar.dart';

class SlidingAppBars extends StatefulWidget {
  const SlidingAppBars({super.key});

  @override
  State<SlidingAppBars> createState() => _SlidingAppBarsState();
}

class _SlidingAppBarsState extends State<SlidingAppBars>
    with SingleTickerProviderStateMixin {
  bool _visible = true;
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5)).then((value) {
      setState(() {
        _visible = !_visible;
      });
    });
    return Column(
      children: [
        SlidingAppBar(
          slidingOffset: const Offset(0, -1),
          controller: _controller,
          visible: _visible,
          child: AppBar(
            title: const Text('AppBar'),
          ),
        ),
      ],
    );
  }
}
