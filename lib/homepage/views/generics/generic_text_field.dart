import 'package:flutter/material.dart';

class GenericHomePageTextField extends StatelessWidget {
  const GenericHomePageTextField({
    super.key,
    required this.onChanged,
    required this.mainColor,
    this.controller,
    this.focusNode,
    this.suffixIcon,
    this.hintText,
    this.autoFocus = false,
  });

  final Color mainColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Icon? suffixIcon;
  final String? hintText;
  final bool autoFocus;
  final void Function(String) onChanged;

  static const contentPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: autoFocus,
      autocorrect: false,
      textAlignVertical: const TextAlignVertical(y: 1),
      cursorColor: mainColor,
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        suffixIconColor: mainColor,
        contentPadding: contentPadding,
        hintText: hintText,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 1),
        ),
      ),
    );
  }
}
