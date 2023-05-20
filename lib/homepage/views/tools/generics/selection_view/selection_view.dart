import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selection_view/widgets/selection_view_appbar.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selection_view/widgets/selection_view_button.dart';

abstract class SelectionView extends ConsumerWidget {
  const SelectionView({
    super.key,
    required this.title,
    required this.proceedButtonTitle,
    required this.onProceed,
  });

  static const double proceedButtonToScreenWidthRatio = 0.85;
  final String title;
  final String proceedButtonTitle;
  final void Function(List<int>) onProceed;

  Widget body(WidgetRef ref);
  bool get showAppbarActions => true;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final screenWidth = MediaQueryData.fromView(View.of(context)).size.width;
    return Scaffold(
      appBar: SelectionViewAppbar(
        title: title,
        showActions: showAppbarActions,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 100,
            child: body(ref),
          ),
          SizedBox(
            width: screenWidth * proceedButtonToScreenWidthRatio,
            child: GenericSelectionViewButton(
              title: proceedButtonTitle,
              onPressed: onProceed,
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          )
        ],
      ),
    );
  }
}
