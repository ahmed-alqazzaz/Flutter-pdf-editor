import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/homepage/bloc/home_bloc.dart';
import '../../../../crud/pdf_db_manager/data/data.dart';
import '../../generics/pdf_file_list_tile.dart';
import '../../generics/tools_List_view.dart';
import '../../tools/generics/tool.dart';
import '../../tools/generics/tools.dart';

class ToolsBottomSheet extends StatelessWidget {
  const ToolsBottomSheet._({required this.file, required this.tools});
  factory ToolsBottomSheet(
      {required BuildContext context, required PdfFile file}) {
    const tools = Tools();
    final bloc = context.read<HomePageBloc>();
    return ToolsBottomSheet._(file: file, tools: [
      tools.rename(
          onTap: () => tools.actions
              .rename(context: context, file: file)
              .then(Navigator.of(context).pop)),
      tools.delete(onTap: () {
        tools.actions
            .delete(bloc: bloc, context: context, file: file)
            .then(Navigator.of(context).pop);
      }),
      tools.share(
          onTap: () =>
              tools.actions.share(file: file).then(Navigator.of(context).pop)),
      tools.compress(
          onTap: () => tools.actions.compress(context: context, file: file)),
      tools.discardPages(
          onTap: () => tools.actions.discardPages(
              context: context,
              file: file,
              onFinnished: Navigator.of(context).pop)),
      tools.extractPages(
          onTap: () => tools.actions.extractPages(
              context: context,
              file: file,
              onFinnished: Navigator.of(context).pop)),
    ]);
  }

  final PdfFile file;
  final List<Tool> tools;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PdfFileListTile(
          file: file,
        ),
        Expanded(
          child: ToolsListView.forBottomSheet(
            tools: tools,
          ),
        ),
      ],
    );
  }
}
