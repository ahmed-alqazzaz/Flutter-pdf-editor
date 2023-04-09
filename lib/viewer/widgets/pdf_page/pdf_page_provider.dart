import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page.dart';
import 'package:rxdart/rxdart.dart';

import '../../providers/word_interaction_provider.dart';
import 'bloc/page_bloc.dart';

class PdfPageProvider extends StatelessWidget {
  const PdfPageProvider({
    super.key,
    required this.scaffoldKey,
    required this.pageNumber,
    required this.viewportController,
    required this.appBarsVisibilityController,
    required this.scrollController,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;
  final int pageNumber;
  final BehaviorSubject<Matrix4> viewportController;
  final BehaviorSubject<bool> appBarsVisibilityController;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [
        // Override is necessary to avoid overlap with
        // other pages that are also visible
        wordInteractionProvider.overrideWith(
          (ref) => WordInteractionModel(),
        )
      ],
      child: BlocProvider(
        create: (context) => PageBloc(),
        child: PdfPage(
          scaffoldKey: scaffoldKey,
          scrollController: scrollController,
          pageNumber: pageNumber,
          viewportController: viewportController,
          appBarsVisibilityController: appBarsVisibilityController,
        ),
      ),
    );
  }
}
