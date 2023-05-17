import 'package:flutter/material.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_pages_view.dart/selectable_pdf_pages/selectable_pdf_page.dart';

import '../../../../../../crud/pdf_to_image_converter/data.dart';

class SelectablePdfPages extends StatelessWidget {
  const SelectablePdfPages({
    super.key,
    required this.pages,
    this.pagesPerRow = 3,
  });

  final Map<int, PageImage> pages;
  final int pagesPerRow;
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: pages.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: pagesPerRow,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: pages[1]!.size.aspectRatio,
      ),
      itemBuilder: (context, index) {
        return SelectablePdfPage(
          imagePath: pages[index + 1]!.path,
          index: index + 1,
        );
      },
    );
  }
}
