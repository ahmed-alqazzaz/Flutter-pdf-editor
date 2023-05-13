import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../crud/pdf_db_manager/data/data.dart';

class FilesListView extends StatelessWidget {
  const FilesListView({
    super.key,
    required this.pdfFiles,
    required this.onOptionsIconTapped,
    required this.onFileCached,
    required this.onFileTapped,
  });
  static const double contentLeftPadding = 16;
  static const double listTileTitleHorizontalGap = 10;
  static const double listTileTitleBottomPadding = 10;
  static const int listTileTitleMaxLines = 1;

  static const Color listTileSubtitleColor = Color.fromARGB(255, 160, 160, 160);

  static const double trailingIconSize = 30;
  static const double trailingIconSplashRadius = 25;

  static const double coverImageBorderRadius = 3;
  static const double coverImageAspectRatio = 0.85;
  static const int coverImageLoadingThreshold = 1500;

  final List<PdfFile> pdfFiles;
  final void Function(PdfFile) onFileTapped;
  final void Function(PdfFile) onOptionsIconTapped;
  final void Function(PdfFile) onFileCached;

  static ListTile tileGenerator({
    required PdfFile file,
    Widget? trailing,
    void Function(PdfFile)? onFileCached,
  }) {
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

    Widget coverImageGenerator() {
      final timer = Stopwatch()..start();
      return FutureBuilder(
        future: file.coverPagePath,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (onFileCached != null) onFileCached(file);
            return ClipRRect(
                borderRadius: BorderRadius.circular(coverImageBorderRadius),
                child: AspectRatio(
                  aspectRatio: coverImageAspectRatio,
                  child: Image.file(
                    File(snapshot.data!.path),
                    fit: BoxFit.cover,
                  ),
                ));
          } else {
            // show circular progress indicator if it's
            // been loading for more than 1.5 seconds
            if (timer.elapsed.inMilliseconds > coverImageLoadingThreshold) {
              return const CircularProgressIndicator();
            }
            return const RawImage();
          }
        },
      );
    }

    return ListTile(
      horizontalTitleGap: listTileTitleHorizontalGap,
      title: titleGenerator(),
      subtitle: subtitleGenerator(),
      contentPadding: const EdgeInsets.only(left: contentLeftPadding),
      trailing: trailing,
      leading: coverImageGenerator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final file = pdfFiles[index];
        return TextButton(
          onPressed: () => onFileTapped(file),
          child: tileGenerator(
            file: file,
            onFileCached: onFileCached,
            trailing: IconButton(
              iconSize: trailingIconSize,
              splashRadius: trailingIconSplashRadius,
              onPressed: () => onOptionsIconTapped(file),
              icon: const Icon(
                Icons.more_vert_outlined,
                size: trailingIconSize,
              ),
            ),
          ),
        );
      },
      itemCount: pdfFiles.length,
    );
  }
}
