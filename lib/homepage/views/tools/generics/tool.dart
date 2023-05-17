import 'package:flutter/material.dart';
import 'package:pdf_editor/helpers/custom_icons.dart/custom_icons.dart';

@immutable
class Tool {
  const Tool({
    required this.text,
    required this.icon,
    required this.onTap,
  });
  final IconData icon;
  final String text;
  final void Function(BuildContext) onTap;
}
