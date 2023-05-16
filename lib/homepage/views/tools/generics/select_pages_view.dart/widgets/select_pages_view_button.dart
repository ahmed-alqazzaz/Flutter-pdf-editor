import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../generics/generic_button.dart';
import '../../selectable_pdf_pages.dart/providers/selectable_pdf_pages_provider.dart';

class SelectPagesViewButton extends ConsumerWidget {
  const SelectPagesViewButton({
    super.key,
    required this.size,
    required this.onPressed,
    required this.title,
  });

  final Size size;
  final String title;
  final void Function() onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPagesCount =
        ref.watch(selectedPagesProvider).selectedIndexes.length;
    return GenericButton.large(
      onPressed: () {},
      color: selectedPagesCount == 0
          ? const Color.fromRGBO(186, 186, 186, 1)
          : Colors.deepPurple,
      textColor: Colors.white,
      size: size,
      child: Text(
        '$title ($selectedPagesCount)',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
