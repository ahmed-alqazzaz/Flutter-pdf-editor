import 'package:flutter/material.dart';

class GenericHomePageAppBar extends StatelessWidget {
  const GenericHomePageAppBar({
    super.key,
    this.actions,
    this.title,
    this.leading,
  });

  static const backgroundColor = Colors.white;
  static const shadowColor = Color.fromARGB(100, 228, 228, 228);
  static const iconsColor = Color.fromARGB(200, 33, 33, 33);
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
      backgroundColor: backgroundColor,
      elevation: 3,
      shadowColor: shadowColor,
      title: title,
      iconTheme: const IconThemeData(color: iconsColor),
      actions: actions,
    );
  }
}
