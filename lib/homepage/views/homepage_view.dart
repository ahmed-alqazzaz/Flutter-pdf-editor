import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/crud/pdf_db_manager/data/data.dart';

import 'package:pdf_editor/homepage/bloc/home_events.dart';
import 'package:pdf_editor/homepage/views/app_bars/home_app_bar.dart';
import 'package:pdf_editor/homepage/views/app_bars/home_navigation_bar.dart';

import '../../helpers/custom_icons.dart/custom_icons.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_states.dart';
import 'files_view/add_files_button.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Container(),
      appBar: const HomeAppBar(),
      bottomNavigationBar: const HomeNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const AddFilesButton(),
      body: const FilesListView(),
    );
  }
}

class FilesListView extends StatelessWidget {
  const FilesListView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomePageBloc>();
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        state as HomePageStateDisplayingFiles;
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final file = state.pdfFiles[index];
            return TextButton(
              onPressed: () {},
              child: ListTile(
                horizontalTitleGap: 25,
                title: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    file.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                subtitle: Text(
                  file.uploadDate.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Color.fromARGB(255, 160, 160, 160),
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 16),
                trailing: IconButton(
                  iconSize: 30,
                  splashRadius: 25,
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert_outlined,
                    size: 30,
                  ),
                ),
                leading: FutureBuilder(
                  future: file.coverPagePath,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (!file.isCached) {
                        bloc.add(
                          HomePageEventUpdateFile(
                            file.copyWith(
                              isCached: true,
                            ),
                          ),
                        );
                      }
                      return Image.file(
                        File(snapshot.data!),
                        fit: BoxFit.cover,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  },
                ),
              ),
            );
          },
          itemCount: state.pdfFiles.length,
        );
      },
    );
  }
}
