import 'package:flutter/material.dart';
import 'package:pdf_editor/helpers/custom_icons.dart/custom_icons.dart';

final tools = [
  Tool(
    text: 'Compress',
    icon: CustomIcons.compressAlt,
    onTap: () {},
  ),
  Tool(
    text: 'Merge',
    icon: Icons.merge,
    onTap: () {},
  ),
  Tool(
    text: 'Share',
    icon: Icons.share,
    onTap: () {},
  ),
  Tool(
    text: 'Rename',
    icon: CustomIcons.rename,
    onTap: () {},
  ),
  Tool(
    text: 'Delete',
    icon: Icons.delete,
    onTap: () {},
  ),
  Tool(
    text: 'Favourite',
    icon: Icons.star_border_outlined,
    onTap: () {},
  ),
];

@immutable
class Tool {
  const Tool({
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final IconData icon;
  final String text;
  final void Function() onTap;
}
