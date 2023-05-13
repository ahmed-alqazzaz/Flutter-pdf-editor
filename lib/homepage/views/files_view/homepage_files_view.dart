import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:pdf_editor/homepage/views/generics/tools/tools_List_view.dart';

import '../../../bloc/app_bloc.dart';
import '../../../crud/pdf_db_manager/data/data.dart';
import '../../bloc/home_bloc.dart';
import '../../bloc/home_events.dart';
import '../../bloc/home_states.dart';
import '../generics/tools/data/tool.dart';
import '../generics/tools/tools.dart';
import 'widgets/add_files_button.dart';
import 'widgets/files_list_view.dart';

class HomePageFilesView extends StatefulWidget {
  const HomePageFilesView({super.key});

  @override
  State<HomePageFilesView> createState() => _HomePageFilesViewState();
}

class _HomePageFilesViewState extends State<HomePageFilesView>
    with AutomaticKeepAliveClientMixin<HomePageFilesView> {
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
          // log(result.files.first.size.toString());
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
        buildWhen: (previous, current) {
          if (current is HomePageStateDisplayingFiles) {
            return true;
          }
          return false;
        },
        builder: (context, state) {
          state as HomePageStateDisplayingFiles;
          return FilesListView(
            onFileTapped: (file) async {
              final document = await PdfDocument.openFile(file.path);
              final page = await document.getPage(1);
              final timer = Stopwatch()..start();
              final texture = await page.createTexture();

              log(await texture
                  .updateRect(
                      width: 250,
                      height: 500,
                      fullHeight: 500,
                      fullWidth: 250,
                      textureHeight: 500,
                      textureWidth: 250,
                      documentId: document.id)
                  .then((value) => '$value'));
              log(timer.elapsedMilliseconds.toString());
              log(texture.textureHeight.toString());
              // appBloc.add(AppEventDisplayPdfViewer(file.path));
            },
            pdfFiles: state.pdfFiles,
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
            onOptionsIconTapped: (file) {
              showModalBottomSheet(
                context: context,
                enableDrag: true,
                useRootNavigator: true,
                constraints: const BoxConstraints(
                  minWidth: 411,
                  maxHeight: 420,
                ),
                builder: (context) {
                  return Column(
                    children: [
                      FilesListView.tileGenerator(file: file),
                      Expanded(
                        child: ToolsListView.forBottomSheet(
                          tools: <Tool>[
                            ...genericTools,
                            Tool(
                              text: 'Favourite',
                              icon: Icons.star_border_outlined,
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
