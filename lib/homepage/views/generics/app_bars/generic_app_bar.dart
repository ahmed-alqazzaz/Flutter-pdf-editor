import 'package:flutter/material.dart';

class GenericHomePageAppBar extends StatelessWidget {
  const GenericHomePageAppBar({
    super.key,
    this.actions,
    this.title,
    this.leading,
  });

  static const searchIcon = Icon(Icons.search_outlined);
  static const titleTextColor = Color.fromARGB(255, 26, 26, 26);

  final List<Widget>? actions;
  final Widget? title;
  final Widget? leading;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: leading,
      title: title,
      actions: actions,
    );
  }
}
