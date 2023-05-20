import 'package:flutter/material.dart';

import '../tools/generics/tool.dart';

class ToolsListView extends StatelessWidget {
  const ToolsListView({
    super.key,
    required this.tools,
    required this.tileVisualDensity,
    this.tileTrailing,
  });
  const ToolsListView.forBottomSheet({
    super.key,
    this.tileTrailing,
    required this.tools,
  }) : tileVisualDensity = -4;

  const ToolsListView.forToolsView({
    super.key,
    this.tileTrailing,
    required this.tools,
  }) : tileVisualDensity = 0;

  static const iconColor = Colors.deepPurple;
  final Widget? tileTrailing;
  final double tileVisualDensity;
  final List<Tool> tools;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tools.length,
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () => tools[index].onTap(context),
          child: ListTile(
            visualDensity: VisualDensity(vertical: tileVisualDensity),
            title: Text(tools[index].text),
            trailing: tileTrailing,
            leading: Icon(
              tools[index].icon,
              color: iconColor,
            ),
          ),
        );
      },
    );
  }
}
