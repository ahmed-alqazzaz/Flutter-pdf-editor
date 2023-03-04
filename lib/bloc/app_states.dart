import 'package:equatable/equatable.dart';

abstract class AppState extends Equatable {
  const AppState();
  @override
  List<Object?> get props => [];
}

class AppStateInitial extends AppState {
  const AppStateInitial();
}

class AppStateDisplayingPdfViewer extends AppState {
  const AppStateDisplayingPdfViewer();
}
