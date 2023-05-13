import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf_editor/crud/pdf_db_manager/pdf_files_manager.dart';

import 'home_events.dart';
import 'home_states.dart';

class HomePageBloc extends Bloc<HomePageEvent, HomePageState> {
  final PdfFilesManager pdfFilesManager;
  HomePageBloc(this.pdfFilesManager)
      : super(HomePageStateDisplayingFiles(
          List.unmodifiable(pdfFilesManager.files),
        )) {
    on<HomePageEventDisplayFiles>(
      (event, emit) => emit(
        HomePageStateDisplayingFiles(
          List.unmodifiable(
            pdfFilesManager.files.where(
              event.filter ?? (file) => true,
            ),
          ),
        ),
      ),
    );

    on<HomePageEventAddFile>(
      (event, emit) async => await pdfFilesManager.addFile(event.file).then(
            (_) => add(const HomePageEventDisplayFiles()),
          ),
    );
    on<HomePageEventUpdateFile>((event, emit) {
      pdfFilesManager.files.replaceRange(
        0,
        pdfFilesManager.files.length,
        pdfFilesManager.files.map(
          (file) => file.path == event.file.path ? event.file : file,
        ),
      );
      add(const HomePageEventDisplayFiles());
    });
  }

  @override
  Future<void> close() async {
    await pdfFilesManager.close();
    return super.close();
  }
}
