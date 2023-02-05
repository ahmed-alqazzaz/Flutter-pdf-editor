import 'package:flutter/material.dart';

typedef OnPressed = void Function();

class GenericButton extends StatelessWidget {
  final MaterialStateProperty<Color?>? backgroundColor;
  final Widget child;
  final OnPressed? onPressed;

  const GenericButton(
      {super.key,
      this.backgroundColor,
      required this.child,
      required this.onPressed});

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
                  color: Color.fromARGB(255, 115, 112, 112),
                  width: 1,
                ),
              ),
            ),
          ),
          onPressed: onPressed,
          child: child),
    );
  }
}
