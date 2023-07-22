import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf_editor/bloc/app_bloc.dart';
import 'package:pdf_editor/bloc/app_events.dart';

import '../../../crud/pdf_manipulator/pdf_manipulator.dart';
import '../generics/selectable/selectability_provider.dart';

abstract class ToolView extends ConsumerWidget {
  ToolView({super.key}) : pdfManipulator = PDFManipulator();

  final PDFManipulator pdfManipulator;
  //final void Function() onFinnished;

  void onExit(BuildContext context, WidgetRef ref) {
    Navigator.of(context).pop();
    ref.read(selectabilityProvider).clear();
  }

  Widget body(BuildContext context, WidgetRef ref);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      child: body(context, ref),
      onWillPop: () async {
        onExit(context, ref);
        return false;
      },
    );
  }
}
