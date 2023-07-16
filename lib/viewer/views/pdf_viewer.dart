import 'dart:async';

import 'package:draggable_scrollbar/draggable_scrollbar.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/bloc/app_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';
import 'package:pdf_editor/bloc/app_states.dart';
import 'package:pdf_editor/viewer/providers/pdf_viewer_related/appbars_visibility_provider.dart';

import 'package:pdf_editor/viewer/providers/pdf_viewer_related/scroll_controller_provider.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page.dart';

import '../utils/viewport_controller.dart';
import '../widgets/pdf_page/bloc/page_bloc.dart';

import '../widgets/sliding_appbars/sliding_appbar.dart';

class PdfViewer extends ConsumerStatefulWidget {
  const PdfViewer({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PdfViewerState();
}

class _PdfViewerState extends ConsumerState<ConsumerStatefulWidget>
    with SingleTickerProviderStateMixin {
  final _pdfPageKeys = <int, GlobalKey<PdfPageViewState>>{};
  late final TransformationController _transformationController;
  late final ViewportController _viewportController;

  void updateViewport() => _viewportController.updateViewport(
        scaleFactor: _transformationController.value.getMaxScaleOnAxis(),
        pdfPageKeys: _pdfPageKeys,
      );

  @override
  void initState() {
    _transformationController = TransformationController();
    _viewportController = ViewportController();

    ref.read(appbarVisibilityProvider).controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // hide system UI
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    super.initState();
  }

  @override
  void dispose() {
    _transformationController.dispose();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom],
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scrollController =
        ref.read(scrollControllerProvider).scrollController;

    return WillPopScope(
      onWillPop: () async {
        context.read<AppBloc>().add(const AppEventDisplayHomePage());
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocConsumer<AppBloc, AppState>(
            listener: (context, state) {
              if (state is AppStateDisplayingPdfViewer &&
                  state.isLoading == false) {
                Timer(const Duration(milliseconds: 1500), () {
                  updateViewport();
                });

                // remove progress bar indicator
                ref
                    .read(appbarVisibilityProvider)
                    .showAppBars(isLoading: false);
              }
            },
            builder: (context, state) {
              if (state is AppStateDisplayingPdfViewer) {
                return Stack(
                  children: [
                    const SizedBox(
                      width: 411,
                      height: 800,
                    ),
                    if (state.isLoading == false) ...[
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
                              itemCount:
                                  state.pdfToTmageConverter!.cache.length,
                              itemBuilder: (context, index) {
                                _pdfPageKeys[index + 1] =
                                    GlobalKey<PdfPageViewState>();
                                return BlocProvider(
                                  create: (context) =>
                                      PageBloc(state.pdfToTmageConverter!),
                                  child: PdfPageView(
                                    key: _pdfPageKeys[index + 1]!,
                                    pageNumber: index + 1,
                                    pdfToImageConverter:
                                        state.pdfToTmageConverter!,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                    const SlidingAppBars()
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}


// class PdfViewer extends ConsumerWidget {
//   late final _transformationController = TransformationController();
//   late final _viewportController = ViewportController();
//   final _pdfPageKeys = <int, GlobalKey<PdfPageViewState>>{};

//   void updateViewport() => _viewportController.updateViewport(
//         scaleFactor: _transformationController.value.getMaxScaleOnAxis(),
//         pdfPageKeys: _pdfPageKeys,
//       );

//   PdfViewer({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final appBloc = context.read<AppBloc>();
//     final isLoading = (appBloc.state as AppStateDisplayingPdfViewer).isLoading;
//     final pdfToImageConverter = appBloc.pdfToImageConverter;
//     final scrollController =
//         ref.read(scrollControllerProvider).scrollController;
//     final size = MediaQuery.of(context).size;
//     Timer(const Duration(milliseconds: 1500), () {
//       updateViewport();
//     });
//     return BlocBuilder<AppBloc, AppState>(
//       builder: (context, state) {
//         state as AppStateDisplayingPdfViewer;
//         log(state.x.toString());
//         return ProviderScope(
//           child: SafeArea(
//             child: Scaffold(
//               body: Stack(
//                 children: [
//                   SizedBox(
//                     width: size.width,
//                     height: size.height,
//                   ),
//                   const SlidingAppBars(),
//                   if (!isLoading) ...[
//                     NotificationListener<ScrollEndNotification>(
//                       onNotification: (notification) {
//                         updateViewport();
//                         return true;
//                       },
//                       child: InteractiveViewer(
//                         transformationController: _transformationController,
//                         onInteractionEnd: (details) {
//                           updateViewport();
//                         },
//                         maxScale: 10,
//                         minScale: 0.1,
//                         child: DraggableScrollbar.semicircle(
//                           controller: scrollController,
//                           child: ListView.separated(
//                             separatorBuilder: (context, index) {
//                               return const Divider(
//                                 height: 1,
//                                 color: Color.fromRGBO(186, 186, 186, 100),
//                               );
//                             },
//                             controller: scrollController,
//                             itemCount: pdfToImageConverter!.cache.length,
//                             itemBuilder: (context, index) {
//                               _pdfPageKeys[index + 1] =
//                                   GlobalKey<PdfPageViewState>();
//                               return BlocProvider(
//                                 create: (context) =>
//                                     PageBloc(pdfToImageConverter),
//                                 child: PdfPageView(
//                                   key: _pdfPageKeys[index + 1]!,
//                                   pageNumber: index + 1,
//                                   pdfToImageConverter: pdfToImageConverter,
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

