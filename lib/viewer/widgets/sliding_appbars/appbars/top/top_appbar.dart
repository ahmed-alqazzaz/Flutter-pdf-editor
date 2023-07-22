import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/bloc/app_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';
import 'package:pdf_editor/viewer/widgets/sliding_appbars/appbars/top/tab_icon.dart';

import '../../../../providers/pdf_viewer_related/appbars_visibility_provider.dart';
import '../../generic_sliding_appbar.dart';
import 'appbar_popup_menu_button.dart/appbar_popup_menu_button.dart';

class TopAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const TopAppBar({super.key, required this.tabNumber, required this.title});

  final int tabNumber;
  final String title;
  PreferredSizeWidget appBar() {
    return AppBar(
      leading: Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.arrow_back_sharp),
            onPressed: () {
              context.read<AppBloc>().add(const AppEventDisplayHomePage());
            },
          );
        },
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
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appBarsVisibilityModel = ref.watch(appbarVisibilityProvider);
    final showProgressIndicator = appBarsVisibilityModel.isLoading;
    final controller = appBarsVisibilityModel.controller;

    return Column(
      children: [
        GenericSlidingAppBar(
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
  Size get preferredSize {
    final appBarSize = appBar().preferredSize;
    return Size(appBarSize.width, appBarSize.height * 1.1);
  }
}
