import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf_editor/viewer/providers/appbars_visibility_provider.dart';
import 'package:pdf_editor/viewer/widgets/sliding_appbars/appbars/top/top_appbar.dart';
import 'package:rxdart/rxdart.dart';

import 'generic_sliding_appbar.dart';

class SlidingAppBars extends ConsumerStatefulWidget {
  const SlidingAppBars({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SlidingAppBarsState();
}

class _SlidingAppBarsState extends ConsumerState<ConsumerStatefulWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    // hide system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );

    super.initState();
  }

  @override
  void dispose() {
    // restore system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final areAppbarsVisible =
        ref.watch(appbarVisibilityProvider).areAppbarsVisibile;

    if (areAppbarsVisible) {
      _controller.reverse();

      // show system botom UI
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom],
      );
    } else {
      _controller.forward();

      // hide system bottom UI
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [],
      );
    }
    return Column(
      children: [
        SlidingAppBar(
          slidingOffset: const Offset(0, -1),
          controller: _controller,
          visibility: areAppbarsVisible,
          child: topAppbar(1),
        ),
        const Spacer(flex: 7),
      ],
    );
  }
}
