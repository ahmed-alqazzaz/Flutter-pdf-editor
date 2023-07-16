import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/crud/pdf_manipulator/pdf_manipulator.dart';
import 'package:pdf_editor/homepage/utils/request_directory.dart';
import 'package:pdf_editor/homepage/views/generics/dialogs/delete_file_dialog.dart';
import 'package:pdf_editor/homepage/views/generics/dialogs/rename_file_dialog.dart';
import 'package:pdf_editor/homepage/views/tools/generics/select_files_views/select_files_view.dart';
import 'package:pdf_editor/homepage/views/tools/generics/tool.dart';
import 'package:pdf_editor/homepage/views/tools/tool_views/file_selection_tools/split_file_view.dart';
import 'package:pdf_editor/homepage/views/tools/tool_views/page_selection_tools/insert_pages_view/insert_pages_view.dart';
import 'package:pdf_editor/homepage/views/tools/tool_views/page_selection_tools/insert_pages_view/select_pages_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../bloc/app_bloc.dart';
import '../../../../bloc/app_events.dart';
import '../../../../crud/pdf_db_manager/data/data.dart';
import '../../../../helpers/custom_icons.dart/custom_icons.dart';
import '../../../bloc/home_bloc.dart';
import '../../../bloc/home_events.dart';
import '../tool_views/file_selection_tools/merge_files_view.dart';
import '../tool_views/page_selection_tools/discard_pages_view.dart';
import '../tool_views/page_selection_tools/extract_pages_view.dart';
import 'package:share_plus/share_plus.dart' as x;

typedef OnTap = void Function();

@immutable
class Tools {
  const Tools() : actions = const ToolsOnProceedActions();

  final ToolsOnProceedActions actions;
  Tool compress({required void Function() onTap}) {
    return Tool(
      text: 'Compress',
      icon: CustomIcons.compress,
      onTap: onTap,
    );
  }

  Tool rename({required void Function() onTap}) {
    return Tool(
      text: 'Rename',
      icon: CustomIcons.rename,
      onTap: onTap,
    );
  }

  Tool share({required void Function() onTap}) {
    return Tool(
      text: 'Share',
      icon: Icons.share,
      onTap: onTap,
    );
  }

  Tool delete({required void Function() onTap}) {
    return Tool(text: 'Delete', icon: Icons.delete, onTap: onTap);
  }

  Tool discardPages({required void Function() onTap}) {
    return Tool(
      text: 'Discard Pages',
      icon: Icons.abc,
      onTap: onTap,
    );
  }

  Tool extractPages({required void Function() onTap}) {
    return Tool(
      text: 'Extract Pages',
      icon: Icons.star_border_outlined,
      onTap: onTap,
    );
  }

  Tool merge({required void Function() onTap}) {
    return Tool(
      text: 'Merge',
      icon: Icons.merge,
      onTap: onTap,
    );
  }

  Tool convertPdfToImage({required void Function() onTap}) {
    return Tool(
      text: 'Convert Pdf To Image',
      icon: Icons.merge,
      onTap: onTap,
    );
  }

  Tool split({required void Function() onTap}) {
    return Tool(
      text: 'Split',
      icon: Icons.call_split_outlined,
      onTap: onTap,
    );
  }

  Tool insert({required void Function() onTap}) {
    return Tool(
      text: 'Insert',
      icon: Icons.abc,
      onTap: onTap,
    );
  }
}

class ToolsOnProceedActions {
  const ToolsOnProceedActions();

  String _fileNameGenerator(
      {required HomePageBloc bloc, required String fileName}) {
    fileNameExtractor(String fileName) =>
        fileName.split('.pdf').first.replaceAll(RegExp(r"\(\d+\)"), "");
    final files = bloc.pdfFilesManager.files;
    final fileNameOccurance = files.isNotEmpty
        ? files.where(
            (element) {
              return fileNameExtractor(element.name) ==
                  fileNameExtractor(fileName);
            },
          ).length
        : 0;

    return '${fileNameExtractor(fileName)}${fileNameOccurance > 0 ? "($fileNameOccurance)" : ""}.pdf';
  }

  Future<void> _navigateTo(
          {required BuildContext context, required Widget screen}) =>
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
  void _navigateHome(BuildContext context) =>
      context.read<AppBloc>().add(const AppEventDisplayHomePage());

  Future<void> delete({
    required HomePageBloc bloc,
    required BuildContext context,
    required PdfFile file,
  }) async =>
      await showDeleteFileDialog(
        context: context,
        onProceed: () {
          bloc.add(HomePageEventDeleteFile(file));
        },
      );

  void compress({required BuildContext context, required PdfFile file}) {
    requestDirectory().then(
      (directory) {
        if (directory != null) {
          final generatedFileName =
              '${file.name.split('.pdf')[0]}(Compressed).pdf';
          final targetPath = '${directory.path}/$generatedFileName';
          PDFManipulator()
              .compressFile(
                filePath: file.path,
                targetPath: targetPath,
              )
              .then((value) => _navigateHome(context));
        }
      },
    );
  }

  void discardPages({
    required BuildContext context,
    required PdfFile file,
  }) {
    final homePageBloc = context.read<HomePageBloc>();
    _navigateTo(
      context: context,
      screen: DiscardPagesView(
        file: file,
        generatedFileName:
            _fileNameGenerator(bloc: homePageBloc, fileName: file.name),
        onProceed: (File file) {
          homePageBloc.add(
            HomePageEventAddFile(
              PdfFile(
                path: file.path,
                uploadDate: DateTime.now(),
                coverPagePath: null,
              ),
            ),
          );
        },
      ),
    );
  }

  void extractPages({required BuildContext context, required PdfFile file}) {
    final homePageBloc = context.read<HomePageBloc>();
    _navigateTo(
      context: context,
      screen: ExtractPagesView(
        file: file,
        generatedFileName: _fileNameGenerator(
          bloc: homePageBloc,
          fileName: file.name,
        ),
        onProceed: (File file) {
          homePageBloc.add(
            HomePageEventAddFile(
              PdfFile(
                path: file.path,
                uploadDate: DateTime.now(),
                coverPagePath: null,
              ),
            ),
          );
        },
      ),
    );
  }

  void share({required PdfFile file}) => Share.shareFiles([file.path]);

  void rename({required BuildContext context, required PdfFile file}) {
    final homePageBloc = context.read<HomePageBloc>();
    showRenameFileDialog(
      context: context,
      fileName: file.name,
      onFileNamedChanged: (newName) {
        final newFile = file.updateName(newName);
        PDFManipulator()
            .relocateFile(originalPath: file.path, targetPath: newFile.path);
        if (file.coverPagePath != null) {}
        homePageBloc.add(HomePageEventUpdateFile(newFile));
      },
    );
  }

  void insert({
    required BuildContext context,
    required PdfFile file1,
    required PdfFile file2,
  }) {
    final homePageBloc = context.read<HomePageBloc>();
    _navigateTo(
      context: context,
      screen: SelectPagesView(
        file: file1,
        onProceed: (selectedPages) {
          _navigateTo(
            context: context,
            screen: InsertPagesView(
              file1: file1,
              file2: file2,
              selectedFile1Pages: selectedPages,
              generatedFileName: _fileNameGenerator(
                bloc: homePageBloc,
                fileName: file2.name,
              ),
              onProceed: (file) {
                homePageBloc.add(
                  HomePageEventAddFile(
                    PdfFile(
                      path: file.path,
                      uploadDate: DateTime.now(),
                      coverPagePath: null,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  void split({required BuildContext context, required PdfFile file}) {
    final homePageBloc = context.read<HomePageBloc>();

    _navigateTo(
      context: context,
      screen: SplitFileView(
        file: file,
        generatedFileNames: [
          _fileNameGenerator(
            bloc: homePageBloc,
            fileName: '${file.name.split('.pdf').first}(part1).pdf',
          ),
          _fileNameGenerator(
            bloc: homePageBloc,
            fileName: '${file.name.split('.pdf').first}(part2).pdf',
          ),
        ],
        onProceed: (files) async {
          files.listen(
            (file) {
              homePageBloc.add(
                HomePageEventAddFile(
                  PdfFile(
                    path: file.path,
                    uploadDate: DateTime.now(),
                    coverPagePath: null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void merge({required BuildContext context, required List<PdfFile> files}) {
    final homePageBloc = context.read<HomePageBloc>();
    _navigateTo(
        context: context,
        screen: SelectFilesView(
          files: files,
          onProceed: (selectedIndices) {
            _navigateTo(
              context: context,
              screen: MergeFilesView(
                files: [
                  for (int i = 0; i < files.length; i++) ...[
                    if (selectedIndices.contains(i)) files[i]
                  ]
                ],
                onProceed: (file) {
                  homePageBloc.add(
                    HomePageEventAddFile(
                      PdfFile(
                        path: file.path,
                        uploadDate: DateTime.now(),
                        coverPagePath: null,
                      ),
                    ),
                  );
                },
                generatedFileName: _fileNameGenerator(
                  bloc: context.read<HomePageBloc>(),
                  fileName: 'merged.pdf',
                ),
              ),
            );
          },
        ));
  }
}
