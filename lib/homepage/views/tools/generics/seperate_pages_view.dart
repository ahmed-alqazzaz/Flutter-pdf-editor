import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../crud/pdf_db_manager/data/data.dart';
import '../../generics/app_bars/generic_app_bar.dart';
import '../../generics/selectable/selectability_provider.dart';

class SeperatePagesView extends ConsumerStatefulWidget {
  const SeperatePagesView({
    super.key,
    required this.file,
    required this.title,
    required this.seperator,
  });

  final PdfFile file;
  final String title;
  final Widget Function(int index) seperator;
  @override
  ConsumerState<SeperatePagesView> createState() => _InsertPagesViewState();
}

class _InsertPagesViewState extends ConsumerState<SeperatePagesView> {
  late final ScrollController _controller;
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          AppBar(
            title: Text(
              widget.title,
              style:
                  const TextStyle(color: GenericHomePageAppBar.titleTextColor),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: widget.file.pages,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final pages = snapshot.data!;
                  ref.read(selectabilityProvider).setIndexCount(pages.length);
                  return ListView.separated(
                    controller: _controller,
                    itemCount: pages.length,
                    separatorBuilder: (context, index) {
                      return widget.seperator(index);
                    },
                    itemBuilder: (context, index) {
                      // TODO: implement a getter for the size
                      final page = pages[index + 1];
                      final pageSize = page.size;
                      final screenToPdfWidthRatio =
                          screenWidth / pageSize.width;
                      final height = pageSize.height * screenToPdfWidthRatio;
                      return SizedBox.fromSize(
                        size: Size(screenWidth, height),
                        child: Image.file(
                          File(page.path),
                          width: screenWidth,
                          height: height,
                        ),
                      );
                    },
                  );
                }
                return const LinearProgressIndicator();
              },
            ),
          ),
        ],
      ),
    );
  }
}
