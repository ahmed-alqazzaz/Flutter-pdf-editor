import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../helpers/custom_icons.dart/custom_icons.dart';
import '../../../../generics/app_bars/generic_app_bar.dart';
import '../../../../generics/selectable/selectability_provider.dart';

class SelectionViewAppbar extends ConsumerWidget
    implements PreferredSizeWidget {
  const SelectionViewAppbar({
    super.key,
    required this.title,
    required this.showActions,
  });

  final String title;
  final bool showActions;
  static const _textColor = GenericHomePageAppBar.titleTextColor;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: _textColor,
        ),
      ),
      actions: [
        if (showActions) ...[
          IconButton(
              onPressed: () {
                ref.read(selectabilityProvider).clear();
              },
              icon: const Icon(CustomIcons.unselect)),
          IconButton(
            onPressed: () {
              final selectabilityModel = ref.read(selectabilityProvider);
              final pageCount = selectabilityModel.indexCount;
              if (pageCount != null) {
                selectabilityModel.selectMany(
                  List.generate(pageCount, (index) => index),
                );
              } else {
                throw UnimplementedError();
              }
            },
            icon: const Icon(Icons.select_all_sharp),
          )
        ],
      ],
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
