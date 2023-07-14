import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  GenericButton.large({
    super.key,
    required this.color,
    required this.textColor,
    required this.onPressed,
    required this.child,
    required this.size,
  })  : border = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          side: const BorderSide(
            color: Color.fromRGBO(186, 186, 186, 100),
            width: 1,
          ),
        ),
        padding = const EdgeInsets.all(0);

  GenericButton.small({
    super.key,
    required this.color,
    required this.textColor,
    required this.onPressed,
    required this.child,
    required this.size,
  })  : border = RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding = const EdgeInsets.symmetric(horizontal: 15, vertical: 3);

  final Color color;
  final Color textColor;
  final EdgeInsets padding;
  final RoundedRectangleBorder border;
  final Size size;
  final void Function() onPressed;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        fixedSize: MaterialStatePropertyAll(size),
        backgroundColor: MaterialStatePropertyAll(color),
        padding: MaterialStatePropertyAll(padding),
        shape: MaterialStatePropertyAll(border),
        foregroundColor: MaterialStatePropertyAll(textColor),
      ),
      child: child,
    );
  }
}
