import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pdf_editor/helpers/custom_icons.dart/custom_icons.dart';
import 'package:pdf_editor/homepage/views/generics/app_bars/generic_app_bar.dart';
import 'package:pdf_editor/homepage/views/generics/generic_text_field.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_pages_view.dart/widgets/select_page_expansion_tile.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_pages_view.dart/widgets/select_pages_view_button.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selectable_pdf_pages.dart/providers/selectable_pdf_pages_provider.dart';
import 'package:pdf_editor/homepage/views/tools/generics/selectable_pdf_pages.dart/selectable_pdf_pages.dart';

import '../../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../../generics/generic_button.dart';

class GenericSelectPagesView extends ConsumerWidget {
  const GenericSelectPagesView({
    super.key,
    required this.file,
    required this.title,
    required this.buttonTitle,
  });

  final PdfFile file;
  final String title;
  final String buttonTitle;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
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
                ref.read(selectedPagesProvider).clear();
              },
              icon: const Icon(CustomIcons.unselect)),
          IconButton(
            onPressed: () {
              ref.read(selectedPagesProvider).selectAll();
            },
            icon: const Icon(Icons.select_all_sharp),
          )
        ],
      ),
      body: FutureBuilder(
        future: file.pages,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SelectRangeExpansionTile(),
                Flexible(
                  flex: 50,
                  fit: FlexFit.tight,
                  child: Card(
                    child: SelectablePdfPages(
                      pages: snapshot.data!,
                    ),
                  ),
                ),
                SelectPagesViewButton(
                  size: Size(size.width * 0.85, 40),
                  title: buttonTitle,
                  onPressed: () {},
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
