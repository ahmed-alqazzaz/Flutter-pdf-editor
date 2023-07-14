import 'package:flutter/material.dart';

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
