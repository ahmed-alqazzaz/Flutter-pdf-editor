import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppBarVisibilityModel extends ChangeNotifier {
  bool _areAppbarsVisible = true;
  bool _isLoading = true;
  AnimationController? _controller;

  set controller(AnimationController value) {
    _controller = value;
  }

  AnimationController get controller =>
      _controller != null ? _controller! : throw UnimplementedError();

  bool get areAppbarsVisible => _areAppbarsVisible;
  bool get isLoading => _isLoading;

  void showAppBars({bool isLoading = false}) {
    controller.reverse();
    _areAppbarsVisible = true;
    _isLoading = isLoading;
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    notifyListeners();
  }

  void hideAppbars() {
    controller.forward();
    _areAppbarsVisible = false;
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [],
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

final appbarVisibilityProvider = ChangeNotifierProvider<AppBarVisibilityModel>(
  (ref) => AppBarVisibilityModel(),
);
