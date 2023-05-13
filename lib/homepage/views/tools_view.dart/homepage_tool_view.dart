import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/crud/pdf_to_image_converter/data.dart';

import '../../bloc/home_bloc.dart';
import '../../bloc/home_states.dart';
import '../generics/tools/data/tool.dart';
import '../generics/tools/tools.dart';
import '../generics/tools/tools_List_view.dart';

class HomePageToolsView extends StatelessWidget {
  const HomePageToolsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        state as HomePageStateDisplayingFiles;
        final files = state.pdfFiles;

        return GridView.builder(
          itemCount: files.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (context, index) {
            return FutureBuilder(
              future: files[index].coverPagePath,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SelectablePdfPage(
                    imagePath: snapshot.data!.path,
                    index: index,
                  );
                } else {
                  return Container();
                }
              },
            );
          },
        );
      },
    );
    return ToolsListView.forToolsView(
      tileTrailing: const Icon(Icons.arrow_forward_outlined),
      tools: <Tool>[
        ...genericTools,
        Tool(
          text: 'Merge Files',
          icon: Icons.merge,
          onTap: () {},
        ),
        Tool(
          text: 'Convert PDF to Image',
          icon: Icons.abc_rounded,
          onTap: () {},
        ),
      ],
    );
  }
}

class SelectedPagesModel extends ChangeNotifier {
  SelectedPagesModel();
  final _selectedIndexes = <int>[];
  List<int> get selectedIndexes => List.unmodifiable(_selectedIndexes);
  void onPageTap(int index) {
    if (!_selectedIndexes.contains(index)) {
      _selectedIndexes.add(index);
    } else {
      _selectedIndexes.remove(index);
    }
    super.notifyListeners();
  }
}

final selectedPagesProvider =
    ChangeNotifierProvider((ref) => SelectedPagesModel());

class SelectablePdfPages extends ConsumerWidget {
  const SelectablePdfPages(this.pages, {super.key});

  final List<PageImage> pages;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPagesIndexes =
        ref.read(selectedPagesProvider).selectedIndexes;
    return GridView.builder(
      itemCount: pages.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.85,
      ),
      itemBuilder: (context, index) {
        return SelectablePdfPage(
          imagePath: pages[index].path,
          index: index,
        );
      },
    );
  }
}

class SelectablePdfPage extends ConsumerStatefulWidget {
  const SelectablePdfPage({
    super.key,
    required this.imagePath,
    required this.index,
  });
  static const double aspectRatio = 0.85;
  final String imagePath;
  final int index;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectablePdfPageState();
}

class _SelectablePdfPageState extends ConsumerState<SelectablePdfPage> {
  static const double indexBoxCircularPadding = 3;
  static const double indexBoxOpacity = 0.8;
  static const Color indexBoxColor = Colors.black54;
  static const Color indexBoxTextColor = Colors.white;
  static const double selectionOverlayOpacity = 0.5;
  static const Color selectionOverlayColor = Colors.blue;

  late final selectedPagesModel = ref.read(selectedPagesProvider);
  Widget selectionOverlay(BoxConstraints constraints) {
    return Container(
      color: selectionOverlayColor.withOpacity(selectionOverlayOpacity),
      width: constraints.maxWidth,
      height: constraints.maxHeight,
    );
  }

  Widget selectionSplash() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        onTapUp: (details) {
          setState(() {
            _isSelected = !_isSelected;
          });
          selectedPagesModel.onPageTap(widget.index);
        },
      ),
    );
  }

  Widget indexBox() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(indexBoxCircularPadding),
        color: indexBoxColor.withOpacity(indexBoxOpacity),
      ),
      child: Center(
        child: Text(
          widget.index.toString(),
          style: const TextStyle(color: indexBoxTextColor),
        ),
      ),
    );
  }

  bool _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            AspectRatio(
              aspectRatio: SelectablePdfPage.aspectRatio,
              child: Image.file(
                File(widget.imagePath),
                fit: BoxFit.cover,
              ),
            ),
            if (_isSelected) ...[
              selectionOverlay(constraints),
            ],
            Positioned(
              bottom: 0,
              right: constraints.maxWidth / 3,
              width: constraints.maxWidth / 3,
              height: constraints.maxHeight / 8,
              child: indexBox(),
            ),
            Positioned.fill(child: selectionSplash()),
          ],
        );
      },
    );
  }
}
