import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/generics/selectable/selectability_provider.dart';

import '../../../../../../generics/generic_button.dart';

class GenericSelectionViewButton extends ConsumerWidget {
  const GenericSelectionViewButton({
    super.key,
    required this.onPressed,
    required this.title,
  });
  static const double height = 40;
  final String title;
  final void Function(List<int> selectedIndexes) onPressed;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final selectedIndexes = ref.watch(selectabilityProvider.select(
      (selectabilityModel) => selectabilityModel.selectedIndexes,
    ));
    final selectedPagesCount = selectedIndexes.length;
    return GenericButton.large(
      color: selectedPagesCount == 0
          ? const Color.fromRGBO(186, 186, 186, 1)
          : Colors.deepPurple,
      textColor: Colors.white,
      size: Size(width, height),
      onPressed: () => onPressed(selectedIndexes),
      child: Text(
        '$title ($selectedPagesCount)',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
