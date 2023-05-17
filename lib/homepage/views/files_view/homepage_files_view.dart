import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/homepage/views/tools/tool_views/discard_pages_view.dart';

import 'package:pdf_editor/homepage/views/generics/tools_List_view.dart';

import '../../../bloc/app_bloc.dart';
import '../../../bloc/app_events.dart';
import '../../../crud/pdf_db_manager/data/data.dart';
import '../../../helpers/custom_icons.dart/custom_icons.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_events.dart';
import '../../bloc/home_states.dart';
import '../generics/pdf_file_list_tile.dart';
import '../tools/generics/tool.dart';

import '../tools/generics/select_pages_view.dart/select_pages_view.dart';
import 'widgets/add_files_button.dart';
import 'widgets/files_list_view.dart';

class HomePageFilesView extends StatefulWidget {
  const HomePageFilesView({super.key});

  @override
  State<HomePageFilesView> createState() => _HomePageFilesViewState();
}

class _HomePageFilesViewState extends State<HomePageFilesView>
    with AutomaticKeepAliveClientMixin<HomePageFilesView> {
  static const double _toolsBottomSheetHeight = 420;

  void showToolsBottomSheet(PdfFile file) async {
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
            PdfFileListTile(file: file),
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
    super.build(context);
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
                    isCached: false,
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
            onOptionsIconTapped: showToolsBottomSheet,
            onFileTapped: (file) async {
              appBloc.add(AppEventDisplayPdfViewer(file.path));
            },
            onFileCached: (file) {
              if (!file.isCached) {
                homePageBloc.add(
                  HomePageEventUpdateFile(
                    file.copyWith(
                      isCached: true,
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
