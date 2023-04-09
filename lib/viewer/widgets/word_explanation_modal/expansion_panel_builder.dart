import 'package:flutter/material.dart';

class ExpansionPanelBuilder extends StatefulWidget {
  const ExpansionPanelBuilder({
    super.key,
    required this.children,
    required this.backgroundColor,
  });
  final List<ExpansionPanelItem> children;
  final Color backgroundColor;
  @override
  State<ExpansionPanelBuilder> createState() => _ExpansionPanelBuilderState();
}

class _ExpansionPanelBuilderState extends State<ExpansionPanelBuilder> {
  final _isExpanded = <bool>[true];
  @override
  void initState() {
    for (var _ in widget.children..removeLast()) {
      _isExpanded.add(false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        expansionCallback: (panelIndex, isExpanded) {
          setState(() {
            // set all values tp false
            _isExpanded.fillRange(0, _isExpanded.length, false);
            // assign the new value
            _isExpanded[panelIndex] = !isExpanded;
          });
        },
        children: [
          for (int i = 0; i < widget.children.length; i++) ...[
            ExpansionPanel(
              headerBuilder: (context, isExpanded) => widget.children[i].header,
              isExpanded: () {
                // in case all widgets are
                // unexpanded, expand first panel
                if (i == 0 && !_isExpanded.contains(true)) {
                  return true;
                }
                return _isExpanded[i];
              }(),
              backgroundColor: widget.backgroundColor,
              body: widget.children[i].body,
            )
          ]
        ],
      ),
    );
  }
}

@immutable
class ExpansionPanelItem {
  const ExpansionPanelItem({required this.header, required this.body});
  final Widget header;
  final Widget body;
}
