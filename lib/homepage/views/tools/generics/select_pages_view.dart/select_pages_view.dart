import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf_editor/helpers/custom_icons.dart/custom_icons.dart';
import 'package:pdf_editor/homepage/views/generics/app_bars/generic_app_bar.dart';
import 'package:pdf_editor/homepage/views/generics/selectable/selectability_provider.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_pages_view.dart/widgets/select_page_expansion_tile.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_pages_view.dart/widgets/select_pages_view_button.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_pages_view.dart/selectable_pdf_pages/selectable_pdf_pages.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';

class GenericSelectPagesView extends ConsumerWidget {
  const GenericSelectPagesView({
    super.key,
    required this.file,
    required this.title,
    required this.proceedButton,
  });

  final PdfFile file;
  final String title;
  final GenericSelectPagesButton proceedButton;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final proceedButtonWidth = size.width * 0.85;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            color: GenericHomePageAppBar.titleTextColor,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                ref.read(selectabilityProvider).clear();
              },
              icon: const Icon(CustomIcons.unselect)),
          IconButton(
            onPressed: () {
              final selectabilityModel = ref.read(selectabilityProvider);
              final pageCount = selectabilityModel.indexCount;
              if (pageCount != null) {
                selectabilityModel.selectMany(
                  List.generate(pageCount - 1, (index) => index + 1),
                );
              }
            },
            icon: const Icon(Icons.select_all_sharp),
          )
        ],
      ),
      body: FutureBuilder(
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
                  flex: 50,
                  fit: FlexFit.tight,
                  child: Card(
                    child: SelectablePdfPages(
                      pages: pages,
                    ),
                  ),
                ),
                SizedBox(
                  width: proceedButtonWidth,
                  child: proceedButton,
                ),
                Flexible(
                  flex: 1,
                  child: Container(),
                )
              ],
            );
          }
          return const LinearProgressIndicator();
        },
      ),
    );
  }
}
