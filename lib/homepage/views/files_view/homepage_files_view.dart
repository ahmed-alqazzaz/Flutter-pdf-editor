import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/homepage/views/files_view/widgets/tools_bottm_sheet.dart';

import '../../../bloc/app_bloc.dart';
import '../../../bloc/app_events.dart';
import '../../../crud/pdf_db_manager/data/data.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_events.dart';
import '../../bloc/home_states.dart';
import 'widgets/add_files_button.dart';
import 'widgets/files_list_view.dart';

class HomePageFilesView extends StatelessWidget {
  static const double _toolsBottomSheetHeight = 420;

  const HomePageFilesView({super.key});

  void showToolsBottomSheet(PdfFile file, BuildContext context) async {
    final screenWidth =
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width;

    await showModalBottomSheet(
      context: context,
      enableDrag: true,
      useRootNavigator: true,
      constraints: BoxConstraints(
        minWidth: screenWidth,
        maxHeight: _toolsBottomSheetHeight,
      ),
      builder: (_) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<HomePageBloc>.value(
              value: BlocProvider.of<HomePageBloc>(context),
            ),
            BlocProvider<AppBloc>.value(
              value: BlocProvider.of<AppBloc>(context),
            ),
          ],
          child: WillPopScope(
            onWillPop: () async {
              Navigator.of(_).pop();
              return true;
            },
            child: ToolsBottomSheet(
              file: file,
              context: context,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
          );
        },
      ),
    );
  }
}
