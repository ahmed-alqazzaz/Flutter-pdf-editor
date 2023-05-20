import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/homepage/views/tools/tool_views/file_selection_tools/merge_files_view.dart';
import 'package:pdf_editor/homepage/views/tools/tool_views/page_selection_tools/discard_pages_view.dart';

import 'package:pdf_editor/homepage/views/generics/tools_List_view.dart';

import '../../../bloc/app_bloc.dart';
import '../../../bloc/app_events.dart';
import '../../../crud/pdf_db_manager/data/data.dart';
import '../../../helpers/custom_icons.dart/custom_icons.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_events.dart';
import '../../bloc/home_states.dart';
import '../generics/pdf_file_list_tile.dart';
import '../tools/generics/select_files_views/order_files_view.dart';
import '../tools/generics/tool.dart';

import '../tools/generics/select_pages_view/select_pages_view.dart';
import 'widgets/add_files_button.dart';
import 'widgets/files_list_view.dart';

class HomePageFilesView extends StatelessWidget {
  static const double _toolsBottomSheetHeight = 420;

  const HomePageFilesView({super.key});

  void showToolsBottomSheet(PdfFile file, BuildContext context) async {
    final screenWidth =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;
    final tools = <Tool>[
      Tool(
        text: 'Compress',
        icon: CustomIcons.compress,
        onTap: (context) {},
      ),
      Tool(
        text: 'Rename',
        icon: CustomIcons.rename,
        onTap: (context) {},
      ),
      Tool(
        text: 'Delete',
        icon: Icons.delete,
        onTap: (context) {},
      ),
      Tool(
        text: 'Discard Pages',
        icon: Icons.abc,
        onTap: (context) {
          print('working');

          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => DiscardPagesView(file: file)),
          );
        },
      ),
      Tool(
        text: 'Share',
        icon: Icons.share,
        onTap: (context) {},
      ),
      Tool(
        text: 'Favourite',
        icon: Icons.star_border_outlined,
        onTap: (context) {},
      ),
    ];
    await showModalBottomSheet(
      context: context,
      enableDrag: true,
      useRootNavigator: true,
      constraints: BoxConstraints(
        minWidth: screenWidth,
        maxHeight: _toolsBottomSheetHeight,
      ),
      builder: (context) {
        return Column(
          children: [
            PdfFileListTile(
              file: file,
              onFileCached: (file) {},
            ),
            Expanded(
              child: ToolsListView.forBottomSheet(tools: tools),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      final files = context.read<HomePageBloc>().pdfFilesManager.files;
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => BlocProvider<HomePageBloc>.value(
                  value: BlocProvider.of<HomePageBloc>(context),
                  child: ReorderableFilesView(
                    files: files,
                    onPdfFileCached: (PdfFile file) {},
                    onProceed: (List<int> indexes) {},
                    proceedButtonTitle: 'MERGE',
                    title: 'Order files',
                  ),
                )),
      );
    });
    final homePageBloc = context.read<HomePageBloc>();
    final appBloc = context.read<AppBloc>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AddFilesButton(
        onFilesPicked: (FilePickerResult result) {
          for (final path in result.paths) {
            if (path != null) {
              homePageBloc.add(
                HomePageEventAddFile(
                  PdfFile(
                    path: path,
                    uploadDate: DateTime.now(),
                    coverPagePath: null,
                  ),
                ),
              );
            }
          }
        },
      ),
      body: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          state as HomePageStateDisplayingFiles;
          return FilesListView(
            pdfFiles: state.pdfFiles,
            onOptionsIconTapped: (PdfFile file) =>
                showToolsBottomSheet(file, context),
            onFileTapped: (file) async {
              appBloc.add(AppEventDisplayPdfViewer(file.path));
            },
            onFileCached: (file) {},
          );
        },
      ),
    );
  }
}
