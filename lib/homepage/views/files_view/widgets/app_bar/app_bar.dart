import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:pdf_editor/homepage/views/files_view/widgets/app_bar/search_field.dart';

import '../../../generics/app_bars/generic_app_bar.dart';

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GenericHomePageAppBar(
        leading: _isSearching
            ? IconButton(
                icon: const Icon(Icons.arrow_back_outlined),
                onPressed: () => _focusNode.unfocus(),
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {},
              ),
        title: _isSearching
            ? FilesSearchField(
                focusNode: _focusNode,
                suffixIcon: _showClearButton ? const Icon(Icons.clear) : null,
                onChanged: (value) {
                  widget.onQueryUpdated(value);

                  // in case there is text, and the clear button is not present
                  if (value.isNotEmpty && !_showClearButton) {
                    setState(() {
                      _showClearButton = true;
                    });
                  } else if (value.isEmpty && _showClearButton) {
                    setState(() {
                      _showClearButton = false;
                    });
                  }
                },
              )
            : const Text(
                'Files',
                style: TextStyle(color: GenericHomePageAppBar.titleTextColor),
              ),
        actions: [
          if (!_isSearching) ...[
            IconButton(
              onPressed: () {
                setState(() {
                  _focusNode.requestFocus();
                  _isSearching = true;
                });
              },
              icon: searchIcon,
            ),
          ]
        ],
      ),
      onWillPop: () async {
        _focusNode.unfocus();
        return false;
      },
    );
  }
}
