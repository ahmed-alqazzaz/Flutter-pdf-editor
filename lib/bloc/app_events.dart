abstract class AppEvent {
  const AppEvent();
}

class AppEventDisplayPdfViewer extends AppEvent {
  const AppEventDisplayPdfViewer(this.pdfPath);
  final String pdfPath;
}
