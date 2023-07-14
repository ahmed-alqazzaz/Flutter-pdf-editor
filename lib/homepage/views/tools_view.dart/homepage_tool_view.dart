
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/homepage/bloc/home_bloc.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_files_views/select_file_view.dart';
import 'package:pdf_editor/homepage/views/tools/generics/tools.dart';

import '../../../bloc/app_bloc.dart';
import '../../../crud/pdf_db_manager/data/data.dart';
import '../generics/tools_List_view.dart';
import '../tools/generics/tool.dart';

class HomePageToolsView extends StatelessWidget {
  const HomePageToolsView._({required this.tools});
  factory HomePageToolsView(BuildContext context) {
    const tools = Tools();
    final bloc = context.read<HomePageBloc>();
    final files = bloc.pdfFilesManager.files;

    return HomePageToolsView._(
      tools: <Tool>[
        tools.compress(
          onTap: () => _selectFileView(
            context: context,
            files: files,
            onFileTapped: (context, file) =>
                tools.actions.compress(context: context, file: file),
          ),
        ),
        tools.rename(
          onTap: () => _selectFileView(
            context: context,
            files: files,
            onFileTapped: (context, file) =>
                tools.actions.rename(context: context, file: file),
          ),
        ),
        tools.delete(
          onTap: () => _selectFileView(
            context: context,
            files: files,
            onFileTapped: (context, file) {
              tools.actions
                  .delete(context: context, file: file, bloc: bloc)
                  .then(
                (value) {
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
        tools.discardPages(
          onTap: () => _selectFileView(
            context: context,
            files: files,
            onFileTapped: (context, file) {
              tools.actions.discardPages(context: context, file: file);
              Navigator.of(context).pop();
            },
          ),
        ),
        tools.share(
          onTap: () => _selectFileView(
            context: context,
            files: files,
            onFileTapped: (context, file) => tools.actions.share(file: file),
          ),
        ),
        tools.merge(
          onTap: () {
            tools.actions.merge(context: context, files: files);
          },
        ),
        tools.convertPdfToImage(
          onTap: () => _selectFileView(
            context: context,
            files: files,
            onFileTapped: (context, file) => tools.actions.share(file: file),
          ),
        ),
        tools.split(
          onTap: () => _selectFileView(
            context: context,
            files: files,
            onFileTapped: (context, file) =>
                tools.actions.split(file: file, context: context),
          ),
        ),
        tools.insert(
          onTap: () {
            _selectFileView(
              context: context,
              files: files,
              title: 'Select file to extract pages from',
              onFileTapped: (context, file1) {
                _selectFileView(
                  context: context,
                  files: files,
                  onFileTapped: (context, file2) {
                    tools.actions.insert(
                      context: context,
                      file1: file1,
                      file2: file2,
                    );
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }

  static void _selectFileView({
    required BuildContext context,
    required List<PdfFile> files,
    String? title,
    required void Function(BuildContext, PdfFile) onFileTapped,
  }) {
    _navigateTo(
      context: context,
      screen: SelectFileView(
        files: files,
        onFileTapped: onFileTapped,
        title: title,
      ),
    );
  }

  static void _navigateTo({
    required BuildContext context,
    required Widget screen,
  }) =>
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<HomePageBloc>.value(
                value: BlocProvider.of<HomePageBloc>(context),
              ),
              BlocProvider<AppBloc>.value(
                value: BlocProvider.of<AppBloc>(context),
              ),
            ],
            child: screen,
          ),
        ),
      );

  final List<Tool> tools;
  @override
  Widget build(BuildContext context) {
    return ToolsListView.forToolsView(
      tileTrailing: const Icon(Icons.arrow_forward_outlined),
      tools: tools,
    );
  }
}
