import 'package:flutter/material.dart';
import 'package:pdf_editor/viewer/widgets/word_explanation_modal/views/word_explanation_modal_view.dart';

class ExpansionPanelBuilder extends StatefulWidget {
  const ExpansionPanelBuilder({
    super.key,
    required this.children,
    required this.backgroundColor,
    required this.explanationCardsPageViewHeight,
  });

  final List<ExpansionPanelItem> children;
  final double explanationCardsPageViewHeight;
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
    print(widget.children.length);
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
                // in case all panels are
                // unexpanded, expand first panel
                if (i == 0 && !_isExpanded.contains(true)) {
                  return true;
                }
                return _isExpanded[i];
              }(),
              backgroundColor: widget.backgroundColor,
              body: Container(
                padding: const EdgeInsets.symmetric(
                  vertical:
                      WordExplanationModalView.explanationCardsVerticalPadding,
                ),
                height: widget.explanationCardsPageViewHeight,
                child: widget.children[i].body,
              ),
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