import 'package:flutter/material.dart';

import '../../../generics/app_bars/generic_app_bar.dart';

class FilesSearchField extends StatelessWidget {
  const FilesSearchField({
    super.key,
    required this.focusNode,
    required this.onChanged,
    this.suffixIcon,
  });
  static const mainColor = GenericHomePageAppBar.iconsColor;

  final FocusNode focusNode;
  final Icon? suffixIcon;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      focusNode: focusNode,
      autofocus: true,
      autocorrect: false,
      textAlignVertical: const TextAlignVertical(y: 1),
      cursorColor: mainColor,
      decoration: InputDecoration(
        suffixIconColor: mainColor,
        suffixIcon: suffixIcon,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        hintText: 'Find files',
        focusColor: mainColor,
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: mainColor, width: 1),
        ),
      ),
    );
  }
}
