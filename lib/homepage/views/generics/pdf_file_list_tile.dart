import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/homepage/bloc/home_bloc.dart';
import 'package:pdf_editor/homepage/bloc/home_events.dart';
import 'package:pdf_editor/pdf_renderer/renderer.dart';

import '../../../crud/pdf_db_manager/data/data.dart';

class PdfFileListTile extends StatelessWidget {
  const PdfFileListTile({
    super.key,
    required this.file,
    this.trailing,
  });
  static const double contentLeftPadding = 16;
  static const double listTileTitleHorizontalGap = 10;
  static const double listTileTitleBottomPadding = 10;
  static const int listTileTitleMaxLines = 1;
  static const Color listTileSubtitleColor = Color.fromARGB(255, 160, 160, 160);
  static const double coverImageBorderRadius = 3;
  static const double coverImageAspectRatio = 0.85;
  static const int coverImageLoadingThreshold = 1500;

  final PdfFile file;
  final Widget? trailing;

  Widget titleGenerator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: listTileTitleBottomPadding),
      child: Text(
        file.name,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: listTileTitleMaxLines,
      ),
    );
  }

  Widget subtitleGenerator() {
    return Text(
      file.uploadDate.toString(),
      style: const TextStyle(
        fontWeight: FontWeight.w400,
        color: listTileSubtitleColor,
      ),
    );
  }

  Widget coverImageGenerator(HomePageBloc bloc) {
    final coverImagePath = file.coverPagePath;
    final isPathAvailable = coverImagePath != null;
    if (isPathAvailable) {
      return ClipRRect(
          borderRadius: BorderRadius.circular(coverImageBorderRadius),
          child: AspectRatio(
            aspectRatio: coverImageAspectRatio,
            child: Image.file(
              File(coverImagePath),
              fit: BoxFit.cover,
            ),
          ));
    }
    return FutureBuilder<String>(
      future: PdfRenderer.open(file.path).then(
        (converter) {
          bloc.add(
            HomePageEventUpdateFile(
              file.copyWith(coverPagePath: converter.coverImage.path),
            ),
          );
          return converter.coverImage.path;
        },
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          log(snapshot.error.toString());
        }
        if (snapshot.hasData) {
          return ClipRRect(
              borderRadius: BorderRadius.circular(coverImageBorderRadius),
              child: AspectRatio(
                aspectRatio: coverImageAspectRatio,
                child: Image.file(
                  File(snapshot.data!),
                  fit: BoxFit.cover,
                ),
              ));
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      horizontalTitleGap: listTileTitleHorizontalGap,
      title: titleGenerator(),
      subtitle: subtitleGenerator(),
      contentPadding: const EdgeInsets.only(left: contentLeftPadding),
      trailing: trailing,
      leading: coverImageGenerator(context.read<HomePageBloc>()),
    );
  }
}
