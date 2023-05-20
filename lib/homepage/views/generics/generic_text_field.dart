import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GenericHomePageTextField extends StatelessWidget {
  const GenericHomePageTextField({
    super.key,
    required this.mainColor,
    this.onChanged,
    this.controller,
    this.focusNode,
    this.suffixIcon,
    this.hintText,
    this.autoFocus = false,
    this.labelText,
    this.textInputType,
  });

  final Color mainColor;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Icon? suffixIcon;
  final String? hintText;
  final String? labelText;
  final TextInputType? textInputType;
  final bool autoFocus;
  final void Function(String)? onChanged;

  static const contentPadding =
      EdgeInsets.symmetric(vertical: 12, horizontal: 20);
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: autoFocus,
      autocorrect: false,
      textAlignVertical: const TextAlignVertical(y: 1),
      cursorColor: Colors.black,
      keyboardType: textInputType,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: mainColor),
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
