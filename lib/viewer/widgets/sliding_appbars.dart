import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'generic_sliding_appbar.dart';

class SlidingAppBars extends StatefulWidget {
  const SlidingAppBars({
    super.key,
    required this.showAppbarController,
  });
  final BehaviorSubject<bool> showAppbarController;
  @override
  State<SlidingAppBars> createState() => _SlidingAppBarsState();
}

class _SlidingAppBarsState extends State<SlidingAppBars>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<bool>(
            stream: widget.showAppbarController.stream,
            builder: (context, snapshot) {
              PopupMenuOption? selectedOption;
              if (snapshot.hasData) {
                print(snapshot.data);
                return SlidingAppBar(
                  slidingOffset: const Offset(0, -1),
                  controller: _controller,
                  visible: snapshot.data!,
                  child: AppBar(
                    actions: [
                      PopupMenuButton<PopupMenuOption>(
                        initialValue: selectedOption,
                        onSelected: (value) {
                          print(value);
                        },
                        itemBuilder: (context) =>
                            <PopupMenuEntry<PopupMenuOption>>[
                          const PopupMenuItem<PopupMenuOption>(
                            value: PopupMenuOption.share,
                            child: Text("hhhh"),
                          )
                        ],
                      )
                    ],
                    //  backgroundColor: Colors.white,
                    title: const Text('AppBar'),
                  ),
                );
              } else {
                return Container();
              }
            }),
      ],
    );
  }
}

enum PopupMenuOption {
  share,
}
