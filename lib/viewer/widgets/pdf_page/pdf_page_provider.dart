import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/viewer/widgets/pdf_page/pdf_page.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc/page_bloc.dart';

class PdfPageProvider extends StatelessWidget {
  const PdfPageProvider({
    super.key,
    required this.pageNumber,
    required this.viewportController,
    required this.appBarsVisibilityController,
  });
  final int pageNumber;
  final BehaviorSubject<Matrix4> viewportController;
  final BehaviorSubject<bool> appBarsVisibilityController;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PageBloc(),
      child: PdfPage(
        pageNumber: pageNumber,
        viewportController: viewportController,
        appBarsVisibilityController: appBarsVisibilityController,
      ),
    );
  }
}
