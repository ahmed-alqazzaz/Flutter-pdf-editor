import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/generics/selectable/selectability_provider.dart';

import '../../../../../../main.dart';
import '../../../../../utils/range_utils.dart';
import '../../../../generics/generic_text_field.dart';

class SelectRangeExpansionTile extends ConsumerStatefulWidget {
  const SelectRangeExpansionTile({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectRangeExpansionTile();
}

class _SelectRangeExpansionTile extends ConsumerState<ConsumerStatefulWidget> {
  void _textFieldListener() {
    final String textFieldUnsanitizedText = _textEditingController.text;
    final String textFieldText =
        textFieldUnsanitizedText.replaceAll(RegExp(r"[^0-9,\-]"), "");
    final String providerText =
        ref.read(selectabilityProvider).selectedIndexesRangeString;

    if (textFieldText.isEmpty) {
      ref.read(selectabilityProvider).clear();
      return;
    }
    // in case the user typed forbidden value
    if (textFieldText != textFieldUnsanitizedText) {
      _textEditingController.value = TextEditingValue(
        text: textFieldText,
        selection: TextSelection.fromPosition(
          TextPosition(offset: textFieldText.length),
        ),
      );
      return;
    }

    // in case last value is not an integer or
    // the textfield text has not changed
    final textFieldLastValue = int.tryParse(textFieldText.characters.last);
    if (textFieldLastValue == null || textFieldText == providerText) {
      return;
    }

    final List<int> providerPageRange = providerText.isEmpty
        ? []
        : RangeUtils.parseRangeString(providerText).toSet().toList();
    final List<int> textFieldPageRange =
        RangeUtils.parseRangeString(textFieldText).toSet().toList();

    // update provider in case the textfield characters
    // length is less than the provider's, or textfield last number
    // is not in the range of the provider
    if (textFieldText.length < providerText.length ||
        !providerPageRange.contains(textFieldLastValue)) {
      ref.read(selectabilityProvider).clear();
      ref.read(selectabilityProvider).selectMany(
            textFieldPageRange,
          );
    }
  }

  void _selectedPagesListener(
    SelectabilityModel? previous,
    SelectabilityModel next,
  ) {
    final providerText = next.selectedIndexesRangeString;
    final textFieldText = _textEditingController.text;
    if (textFieldText == providerText) {
      return;
    }

    // in case provider Selected pages
    // is not the same as the textfield selected
    // pages, Update the textfield
    _textEditingController.value = TextEditingValue(
      text: providerText,
      selection: TextSelection.fromPosition(
        TextPosition(offset: providerText.length),
      ),
    );
  }

  late final TextEditingController _textEditingController;
  @override
  void initState() {
    // when the textfield'value changes, the textfield listener gets
    // triggered and updates the selectedPagesProvider's
    // selectedPageRange, which in turn updates the textfield in case t
    // their values are different (this happens when the user types forbidden characters)
    // triggering the textfield listener again to match its value with the provider.

    // similarily, when selectedPagesProvider's selectedPages change, the
    // textfield gets updated which in turn updates the provider

    // the base case for preventing infinite recursion is 'textFieldText == providerText'
    _textEditingController = TextEditingController()
      ..addListener(_textFieldListener);
    ref.listenManual(selectabilityProvider, _selectedPagesListener);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return ExpansionTile(
      iconColor: PdfReader.iconsTheme.color,
      textColor: Colors.black,
      title: const Text('Enter page range'),
      children: [
        Padding(
          padding: EdgeInsets.only(
            left: width * 0.05,
            right: width * 0.01,
            bottom: 10,
          ),
          child: GenericHomePageTextField(
            controller: _textEditingController,
            textInputType: TextInputType.number,
            labelText: 'Example: 1-5,10,13',
            mainColor: Colors.black,
          ),
        )
      ],
    );
  }
}
