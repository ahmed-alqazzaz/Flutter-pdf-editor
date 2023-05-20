import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selection_view/widgets/selection_view_appbar.dart';

import '../generics/selectable/selectability_provider.dart';
import 'generics/selection_view/widgets/selection_view_button.dart';

abstract class ToolView extends StatelessWidget {
  const ToolView({super.key});

  Widget body();

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        selectabilityProvider.overrideWith(
          (ref) => SelectabilityModel(),
        )
      ],
      child: body(),
    );
  }
}
