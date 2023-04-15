import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/viewer/widgets/sliding_appbars/appbars/top/tab_icon.dart';

import '../../../../providers/appbars_visibility_provider.dart';
import '../../appbar_popup_menu_button.dart/appbar_popup_menu_button.dart';
import '../../generic_sliding_appbar.dart';

class TopAppBar extends ConsumerWidget with PreferredSizeWidget {
  const TopAppBar({
    super.key,
    required this.tabNumber,
  });

  final int tabNumber;

  PreferredSizeWidget appBar() => AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_sharp),
          onPressed: () {},
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          const IconButton(
            onPressed: null,
            icon: Icon(
              Icons.find_in_page_outlined,
              color: Colors.black,
              size: 28,
            ),
          ),
          TabIcon(tabNumber: tabNumber),
          const AppbarPopupMenuButton(),
        ],
        title: const Text(
          'AppBar',
          style: TextStyle(color: Colors.black),
        ),
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarsVisibilityModel = ref.watch(appbarVisibilityProvider);
    //final areAppbarsVisible = appBarsVisibilityModel.areAppbarsVisible;
    final showProgressIndicator = appBarsVisibilityModel.isLoading;
    final controller = appBarsVisibilityModel.controller;

    return Column(
      children: [
        SlidingAppBar(
          slidingOffset: const Offset(0, -1),
          controller: controller,
          child: appBar(),
        ),
        if (showProgressIndicator) ...[
          const LinearProgressIndicator(),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => appBar().preferredSize;
}
