import 'package:flutter/widgets.dart';
import '../../../../../../custom/custom_popupmenubutton.dart';

class AppbarPopupMenuButton extends StatelessWidget {
  const AppbarPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    PopupMenuOption? selectedOption;
    return PopupMenuButton<PopupMenuOption>(
      initialValue: selectedOption,
      onCanceled: () {},
      onSelected: (value) {
        print(value);
      },
      itemBuilder: (context) => <PopupMenuEntry<PopupMenuOption>>[
        const PopupMenuItem<PopupMenuOption>(
          value: PopupMenuOption.share,
          child: Text("share"),
        ),
        const PopupMenuItem<PopupMenuOption>(
          value: PopupMenuOption.someThingElse,
          child: Text("something else"),
        )
      ],
      offset: const Offset(0, 55),

      // clipBehavior: Clip.hardEdge,
    );
  }
}

enum PopupMenuOption { share, someThingElse }
