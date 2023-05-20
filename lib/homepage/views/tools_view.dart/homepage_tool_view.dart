import 'package:flutter/material.dart';

import '../../../helpers/custom_icons.dart/custom_icons.dart';
import '../generics/tools_List_view.dart';
import '../tools/generics/tool.dart';

class HomePageToolsView extends StatelessWidget {
  const HomePageToolsView({super.key});
  @override
  Widget build(BuildContext context) {
    return ToolsListView.forToolsView(
      tileTrailing: const Icon(Icons.arrow_forward_outlined),
      tools: <Tool>[
        Tool(
          text: 'Compress',
          icon: CustomIcons.compress,
          onTap: (context) {},
        ),
        Tool(
          text: 'Rename',
          icon: CustomIcons.rename,
          onTap: (context) {},
        ),
        Tool(
          text: 'Delete',
          icon: Icons.delete,
          onTap: (context) {},
        ),
        Tool(
          text: 'Discard Pages',
          icon: Icons.abc,
          onTap: (context) {},
        ),
        Tool(
          text: 'Share',
          icon: Icons.share,
          onTap: (context) {},
        ),
        Tool(
          text: 'Merge Files',
          icon: Icons.merge,
          onTap: (context) {},
        ),
        Tool(
          text: 'Convert PDF to Image',
          icon: Icons.abc_rounded,
          onTap: (context) {},
        ),
      ],
    );
  }
}
