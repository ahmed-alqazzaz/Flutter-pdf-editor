import 'package:flutter/material.dart';

import '../../../../main.dart';
import '../../generics/app_bars/generic_app_bar.dart';
import '../../generics/generic_text_field.dart';

class FilesAppBar extends StatefulWidget {
  const FilesAppBar({super.key, required this.onQueryUpdated});

  final void Function(String) onQueryUpdated;
  @override
  State<FilesAppBar> createState() => _FilesAppBarState();
}

class _FilesAppBarState extends State<FilesAppBar> {
  static const searchIcon = Icon(Icons.search_outlined);

  late final FocusNode _focusNode;

  bool _isSearching = false;
  bool _showClearButton = false;
  @override
  void initState() {
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isSearching = false;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  IconButton leading(BuildContext context) {
    if (_isSearching) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_outlined),
        onPressed: () => _focusNode.unfocus(),
      );
    }
    return IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }

  Widget title() {
    if (_isSearching) {
      return filesSearchField();
    }
    return const Text(
      'Files',
      style: TextStyle(color: GenericHomePageAppBar.titleTextColor),
    );
  }

  List<Widget> actions() {
    return [
      if (!_isSearching) ...[
        searchIconButton(),
      ]
    ];
  }

  IconButton searchIconButton() {
    return IconButton(
      onPressed: () {
        setState(() {
          _focusNode.requestFocus();
          _isSearching = true;
        });
      },
      icon: searchIcon,
    );
  }

  Widget filesSearchField() {
    final mainColor = PdfReader.iconsTheme.color;
    const textFieldHintText = 'FindFiles';
    return GenericHomePageTextField(
      focusNode: _focusNode,
      suffixIcon: _showClearButton ? const Icon(Icons.clear) : null,
      hintText: textFieldHintText,
      mainColor: mainColor!,
      onChanged: (value) {
        widget.onQueryUpdated(value);
        // in case there is text, and the clear button is not present
        if (value.isNotEmpty && !_showClearButton) {
          setState(() {
            _showClearButton = true;
          });
        } else if (value.isEmpty && _showClearButton) {
          setState(
            () {
              _showClearButton = false;
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GenericHomePageAppBar(
        leading: leading(context),
        title: title(),
        actions: actions(),
      ),
      onWillPop: () async {
        _focusNode.unfocus();
        return false;
      },
    );
  }
}
