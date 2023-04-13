import 'dart:async';
import 'dart:developer';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/bloc/app_bloc.dart';
import 'package:pdf_editor/bloc/app_states.dart';

import 'package:pdf_editor/viewer/providers/scroll_controller_provider.dart';
import 'package:pdf_editor/viewer/utils/get_args.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page.dart';

import '../crud/pdf_to_image_converter/pdf_to_image_converter.dart';

import '../utils/viewport_controller.dart';
import '../widgets/pdf_page/bloc/page_bloc.dart';
import '../widgets/sliding_appbars/sliding_appbars.dart';
import 'package:bloc/bloc.dart';

class PdfViewer extends ConsumerWidget {
  late final _transformationController = TransformationController();
  late final _viewportController = ViewportController();
  final _pdfPageKeys = <int, GlobalKey<PdfPageViewState>>{};

  void updateViewport() => _viewportController.updateViewport(
        scaleFactor: _transformationController.value.getMaxScaleOnAxis(),
        pdfPageKeys: _pdfPageKeys,
      );

  PdfViewer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pdfToImageConverter = context.getArgument<PdfToImage>()!;
    final scrollController =
        ref.read(scrollControllerProvider).scrollController;
    Timer(const Duration(milliseconds: 1500), () {
      updateViewport();
    });
    return ProviderScope(
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  updateViewport();
                  return true;
                },
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  onInteractionEnd: (details) {
                    updateViewport();
                  },
                  maxScale: 10,
                  minScale: 0.1,
                  child: DraggableScrollbar.semicircle(
                    controller: scrollController,
                    child: ListView.separated(
                      separatorBuilder: (context, index) {
                        return const Divider(
                          height: 1,
                          color: Color.fromRGBO(186, 186, 186, 100),
                        );
                      },
                      controller: scrollController,
                      itemCount: pdfToImageConverter.cache.length,
                      itemBuilder: (context, index) {
                        _pdfPageKeys[index + 1] = GlobalKey<PdfPageViewState>();
                        return BlocProvider(
                          create: (context) => PageBloc(pdfToImageConverter),
                          child: PdfPageView(
                            key: _pdfPageKeys[index + 1]!,
                            pageNumber: index + 1,
                            pdfToImageConverter: pdfToImageConverter,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SlidingAppBars()
            ],
          ),
        ),
      ),
    );
  }
}
