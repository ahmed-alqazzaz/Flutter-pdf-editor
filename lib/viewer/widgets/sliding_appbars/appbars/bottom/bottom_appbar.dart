import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../providers/pdf_viewer_related/appbars_visibility_provider.dart';
import '../../generic_sliding_appbar.dart';

class BottomAppbar extends ConsumerWidget {
  BottomAppbar({super.key});
  final _size = AppBar().preferredSize;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarsVisibilityModel = ref.watch(appbarVisibilityProvider);
    final controller = appBarsVisibilityModel.controller;
    return GenericSlidingAppBar(
      controller: controller,
      slidingOffset: const Offset(0, 1),
      child: Container(
          color: Colors.white,
          height: _size.height,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.g_translate_outlined,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search_rounded,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.grid_view,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Image.asset('assets/dictionary.png'),
              ),
            ],
          )),
    );
  }
}
