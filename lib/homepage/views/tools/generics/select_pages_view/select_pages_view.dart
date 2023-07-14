import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/homepage/views/generics/selectable/selectability_provider.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_pages_view/widgets/selectable_pdf_page.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_pages_view/widgets/select_page_expansion_tile.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selection_view/selection_view.dart';
import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../../pdf_renderer/data.dart';

class GenericSelectPagesView extends SelectionView {
  const GenericSelectPagesView({
    super.key,
    required this.file,
    required super.title,
    required super.proceedButtonTitle,
    required super.onProceed,
  });

  final PdfFile file;

  @override
  Widget body(WidgetRef ref) {
    return FutureBuilder(
      future: file.pages,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pages = snapshot.data!;
          // set the number of indexes to the number of pages
          ref.read(selectabilityProvider).setIndexCount(pages.length);
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SelectRangeExpansionTile(),
              Flexible(
                fit: FlexFit.tight,
                child: Card(
                  child: selectablePdfPages(
                    pages: pages,
                  ),
                ),
              ),
            ],
          );
        }
        return const Column(
          children: [
            LinearProgressIndicator(),
          ],
        );
      },
    );
  }

  Widget selectablePdfPages({
    required List<CachedPage> pages,
    int pagesPerRow = 3,
  }) {
    return GridView.builder(
      itemCount: pages.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: pagesPerRow,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        childAspectRatio: pages[1].size.aspectRatio,
      ),
      itemBuilder: (context, index) {
        return SelectablePdfPage(
          imagePath: pages[index].path,
          index: index + 1,
        );
      },
    );
  }
}
