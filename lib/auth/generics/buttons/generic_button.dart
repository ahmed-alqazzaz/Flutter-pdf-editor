import 'package:flutter/material.dart';

class GenericButton extends StatelessWidget {
  const GenericButton({
    super.key,
    this.backgroundColor,
    required this.child,
    required this.onPressed,
  });

  final MaterialStateProperty<Color?>? backgroundColor;
  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: backgroundColor,
          minimumSize: MaterialStateProperty.all(
            const Size(0, 50),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.all(12),
          ),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: const BorderSide(
                color: Color.fromRGBO(186, 186, 186, 100),
                width: 1,
              ),
            ),
          ),
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}

class GenericButtonn extends StatelessWidget {
  const GenericButtonn({
    super.key,
    this.backgroundColor,
    required this.child,
    required this.onPressed,
    this.padding,
    required this.border,
  });

  final MaterialStateProperty<Color?>? backgroundColor;
  final Widget child;
  final EdgeInsets? padding;
  final RoundedRectangleBorder border;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        backgroundColor: backgroundColor,
        padding: MaterialStateProperty.all(padding),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(border),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
