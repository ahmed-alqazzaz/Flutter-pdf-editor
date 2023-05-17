import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../crud/pdf_db_manager/data/data.dart';
import '../generics/selectable/selectability_provider.dart';
import 'generics/select_pages_view.dart/select_pages_view.dart';
import 'generics/select_pages_view.dart/widgets/select_pages_view_button.dart';

abstract class ToolView extends StatelessWidget {
  const ToolView({super.key, required this.file});
  final PdfFile file;
  Widget toolView({
    required void Function(Set<int>) onProceed,
    required String title,
    required String proceedButtonTitle,
  }) {
    return ProviderScope(
      overrides: [
        selectabilityProvider.overrideWith(
          (ref) => SelectabilityModel(),
        )
      ],
      child: GenericSelectPagesView(
        file: file,
        title: title,
        proceedButton: GenericSelectPagesButton(
          title: proceedButtonTitle,
          onPressed: onProceed,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context);
}
