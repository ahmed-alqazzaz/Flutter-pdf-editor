import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/src/consumer.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selection_view/selection_view.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../generics/pdf_file_list_tile.dart';
import '../../../generics/selectable/selectability_provider.dart';

class ReorderableFilesView extends SelectionView {
  const ReorderableFilesView({
    super.key,
    required super.title,
    required super.proceedButtonTitle,
    required super.onProceed,
    required this.files,
    required this.onPdfFileCached,
  });

  static const instructionMessageColor = Colors.black54;
  static const double instructionMessageMaxWidth = 500;
  static const double instructionMessageHeight = 30;
  static const double instructionMessageVerticalPadding = 10;
  final List<PdfFile> files;
  final Function(PdfFile) onPdfFileCached;
  Widget instructionMessage() {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: instructionMessageMaxWidth,
      ),
      color: instructionMessageColor,
      child: const Center(
        child: Text(
          'drag & drop to order files',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget body(WidgetRef ref) {
    // TODO: they should already be selected
    Timer(const Duration(milliseconds: 500), () {
      ref.read(selectabilityProvider)
        ..setIndexCount(files.length)
        ..selectMany(List.generate(files.length, (index) => index));
    });

    return Consumer(
      builder: (context, ref, child) {
        final indexes = ref.watch(
          selectabilityProvider.select((value) => value.selectedIndexes),
        );
        final size = MediaQuery.of(context).size;
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: instructionMessageVerticalPadding,
                horizontal: size.width * 0.1,
              ),
              child: SizedBox(
                height: instructionMessageHeight,
                width: double.infinity,
                child: instructionMessage(),
              ),
            ),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: files.length,
                onReorder: ref.read(selectabilityProvider).swapIndexes,
                itemBuilder: (context, index) {
                  final file = files[indexes[index]];

                  return PdfFileListTile(
                    key: Key(index.toString()),
                    file: file,
                    onFileCached: onPdfFileCached,
                    trailing: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ReorderableDragStartListener(
                        index: index,
                        child: const Icon(Icons.drag_handle),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  bool get showAppbarActions => false;
}

class ReorderableApp extends StatelessWidget {
  const ReorderableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ReorderableListView Sample')),
        body: const ReorderableExample(),
      ),
    );
  }
}

class ReorderableExample extends StatefulWidget {
  const ReorderableExample({super.key});

  @override
  State<ReorderableExample> createState() => _ReorderableListViewExampleState();
}

class _ReorderableListViewExampleState extends State<ReorderableExample> {
  final List<int> _items = List<int>.generate(5, (int index) => index);

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final Color evenItemColor = colorScheme.primary.withOpacity(0.15);

    return ReorderableListView(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      children: <Widget>[
        for (int index = 0; index < _items.length; index += 1)
          ListTile(
            key: Key('$index'),
            tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
            title: Text('Item ${_items[index]}'),
            trailing: ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
          ),
      ],
      onReorder: (int oldIndex, int newIndex) {
        setState(() {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          final int item = _items.removeAt(oldIndex);
          _items.insert(newIndex, item);
        });
      },
    );
  }
}
